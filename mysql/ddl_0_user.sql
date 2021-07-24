#Create database
CREATE DATABASE IF NOT EXISTS prorec CHARACTER SET UTF8;

USE prorec;
#Create table user
CREATE TABLE IF NOT EXISTS User (
    ID BIGINT(8) UNSIGNED PRIMARY KEY  AUTO_INCREMENT,
    Name NVARCHAR(20) NOT NULL,
    Email NVARCHAR(50) NOT NULL UNIQUE,
    Mobile NVARCHAR(25) NOT NULL UNIQUE,
    Password NVARCHAR(50) NOT NULL,
    Company NVARCHAR(100),
    Enabled BOOLEAN,
    CreatedDate TIMESTAMP,
    LastUpdatedDate TIMESTAMP
);

#Create procedure sp_add_user
DROP PROCEDURE IF EXISTS sp_add_user;
DELIMITER $$
CREATE PROCEDURE sp_add_user(
IN iName NVARCHAR(20),
IN iEmail NVARCHAR(50),
IN iMobile NVARCHAR(15),
IN iPassword NVARCHAR(50),
IN iCompany NVARCHAR(100),
OUT oID BIGINT(8)
)
BEGIN
    DECLARE oldEmail NVARCHAR(50);
    START TRANSACTION;

    SELECT Email INTO  oldEmail FROM User WHERE Email=iEmail AND Enabled = TRUE;

    IF oldEmail IS NULL THEN
        INSERT INTO User(Name,Email,Mobile,Password,Company,Enabled,CreatedDate,LastUpdatedDate) values(
        iName,iEmail,iMobile,iPassword,iCompany,TRUE,current_timestamp(),current_timestamp());

        SET oID = last_insert_id();
    ELSE
        SET oID = -1;
    END IF;

    COMMIT;
END$$
DELIMITER ;

#Update procedure sp_update_user
DROP PROCEDURE IF EXISTS sp_update_user;
DELIMITER $$
CREATE PROCEDURE sp_update_user(
IN iName NVARCHAR(20),
IN iEmail NVARCHAR(50),
IN iMobile NVARCHAR(15),
IN iCompany NVARCHAR(100),
IN iID BIGINT(8)
)
BEGIN

UPDATE User SET Name=iName,Email=iEmail,Mobile=iMobile,Company=iCompany,LastUpdatedDate=current_timestamp()
WHERE ID=iID;

END$$

DELIMITER ;

#Update procedure sp_update_userpwd
DROP PROCEDURE IF EXISTS sp_update_userpwd;
DELIMITER $$
CREATE PROCEDURE sp_update_userpwd(
IN iPassword NVARCHAR(50),
IN iID BIGINT(8)
)
BEGIN

UPDATE User SET Password=iPassword,LastUpdatedDate=current_timestamp()
WHERE ID=iID;

END$$

DELIMITER ;

#Update procedure sp_get_user_by_email_or_mobile
DROP PROCEDURE IF EXISTS sp_get_user_by_email_or_mobile;
DELIMITER $$
CREATE PROCEDURE sp_get_user_by_email_or_mobile(
IN iEmail NVARCHAR(50),
IN iMobile NVARCHAR(15)
)
BEGIN

SELECT * FROM User WHERE (Email=iEmail OR Mobile = iMobile) AND Enabled = TRUE;

END$$

DELIMITER ;

#Update procedure sp_get_user_by_name
DROP PROCEDURE IF EXISTS sp_get_user_by_name;
DELIMITER $$
CREATE PROCEDURE sp_get_user_by_name(
IN iName NVARCHAR(20)
)
BEGIN

SELECT * FROM User WHERE Name LIKE iName AND Enabled = TRUE ORDER BY Name;

END$$

DELIMITER ;

-- Delete procedure sp_delete_user
DROP PROCEDURE IF EXISTS sp_delete_user;
DELIMITER $$
CREATE PROCEDURE sp_delete_user(
IN iID BIGINT(8)
)
BEGIN

UPDATE User SET Enabled=FALSE,LastUpdatedDate=current_timestamp() WHERE ID=iID;

END$$

DELIMITER ;