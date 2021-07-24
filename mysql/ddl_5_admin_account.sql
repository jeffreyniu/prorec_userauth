USE prorec;

-- Create table Admin_Account
#Create table Admin_Account
CREATE TABLE IF NOT EXISTS Admin_Account (
    ID BIGINT(8) UNSIGNED PRIMARY KEY  AUTO_INCREMENT,
    Name NVARCHAR(30) NOT NULL UNIQUE,
    Type NVARCHAR(20) NOT NULL,
    Content TEXT NOT NULL,
    Enabled BOOLEAN,
    CreatedDate TIMESTAMP,
    LastUpdatedDate TIMESTAMP
);

DELIMITER ;

#Create procedure sp_add_admin_account
DROP PROCEDURE IF EXISTS sp_add_admin_account;

DELIMITER $$
CREATE PROCEDURE sp_add_admin_account(
IN iName NVARCHAR(30),
IN iType NVARCHAR(20),
IN iContent TEXT,
OUT oID BIGINT(8)
)
BEGIN

INSERT INTO Admin_Account(Name,Type,Content,Enabled,CreatedDate,LastUpdatedDate) values(
iName,iType,iContent,TRUE,current_timestamp(),current_timestamp());

set oID = last_insert_id();

END$$
DELIMITER ;

#Update procedure sp_update_admin_account
DROP PROCEDURE IF EXISTS sp_update_admin_account;
DELIMITER $$
CREATE PROCEDURE sp_update_admin_account(
IN iName NVARCHAR(30),
IN iType NVARCHAR(20),
IN iContent Text,
IN iID BIGINT(8)
)
BEGIN

UPDATE Admin_Account SET Name=iName,Type=iType,Content=iContent,LastUpdatedDate=current_timestamp()
WHERE ID=iID;

END$$

DELIMITER ;

#Delete procedure sp_reset_admin_account
DROP PROCEDURE IF EXISTS sp_reset_admin_account;
DELIMITER $$
CREATE PROCEDURE sp_reset_admin_account(
IN iEnabled BOOLEAN,
IN iID BIGINT(8)
)
BEGIN

UPDATE Admin_Account SET Enabled=iEnabled,LastUpdatedDate=current_timestamp() WHERE ID=iID;

END$$
DELIMITER ;

#Create procedure sp_get_admin_account_by_id_or_name
DROP PROCEDURE IF EXISTS sp_get_admin_account_by_id_or_name;
DELIMITER $$
CREATE PROCEDURE sp_get_admin_account_by_id_or_name(
IN iID BIGINT(8),
IN iName NVARCHAR(30)
)
BEGIN

SELECT * FROM Admin_Account WHERE ID = iID OR Name = iName;

END$$

DELIMITER ;

#Create procedure sp_get_admin_account
DROP PROCEDURE IF EXISTS sp_get_admin_account;
DELIMITER $$
CREATE PROCEDURE sp_get_admin_account()
BEGIN

SELECT * FROM Admin_Account;

END$$

DELIMITER ;