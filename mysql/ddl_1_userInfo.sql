USE prorec;

-- Create table userinfo
CREATE TABLE IF NOT EXISTS UserInfo (
    ID BIGINT(8) UNSIGNED PRIMARY KEY  AUTO_INCREMENT,
    Name NVARCHAR(20),
    Email NVARCHAR(50),
    Mobile NVARCHAR(25),
    Company NVARCHAR(100),
    Message NVARCHAR(500),
    Enabled BOOLEAN,
    CreatedDate TIMESTAMP,
    LastUpdatedDate TIMESTAMP
);

DELIMITER ;

-- Create procedure sp_add_userinfo
DROP PROCEDURE IF EXISTS sp_add_userinfo;

DELIMITER $$
CREATE PROCEDURE sp_add_userinfo(
IN iName NVARCHAR(20),
IN iEmail NVARCHAR(50),
IN iMobile NVARCHAR(15),
IN iCompany NVARCHAR(100),
IN iMessage NVARCHAR(500),
OUT oID BIGINT(8)
)
BEGIN

INSERT INTO UserInfo(Name,Email,Mobile,Company,Message,Enabled,CreatedDate,LastUpdatedDate) values(
iName,iEmail,iMobile,iCompany,iMessage,TRUE,current_timestamp(),current_timestamp());

SET oID = last_insert_id();

END$$
DELIMITER ;

-- Create procedure sp_get_userinfos
DROP PROCEDURE IF EXISTS sp_get_userinfos;

DELIMITER $$
CREATE PROCEDURE sp_get_userinfos(
IN iFromCreatedDate TIMESTAMP,
IN iToCreatedDate TIMESTAMP
)
BEGIN

SELECT * FROM UserInfo WHERE (CreatedDate BETWEEN iFromCreatedDate AND iToCreatedDate) AND Enabled = TRUE;

END$$

DELIMITER ;