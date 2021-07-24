USE prorec;
#Create table User_Auth
CREATE TABLE IF NOT EXISTS User_Auth (
    ID BIGINT(8) UNSIGNED PRIMARY KEY  AUTO_INCREMENT,
    UserId BIGINT(8) UNSIGNED,
    ApiKey NVARCHAR(50),
    ApiSecret NVARCHAR(50),
    Enabled BOOLEAN,
    CreatedDate TIMESTAMP,
    ExpiredDate TIMESTAMP,
    FOREIGN KEY(UserId) REFERENCES User(ID)
);

DELIMITER ;
#Create procedure sp_add_user_auth
DROP PROCEDURE IF EXISTS sp_add_user_auth;
DELIMITER $$
CREATE PROCEDURE sp_add_user_auth(
IN iUserId BIGINT(8),
IN iApiKey NVARCHAR(50),
IN iApiSecret NVARCHAR(50),
IN iExpiredDate TIMESTAMP,
OUT oID BIGINT(8)
)
BEGIN

DECLARE oldApiKey NVARCHAR(50);

START TRANSACTION;

SELECT ApiKey INTO oldApiKey FROM User_Auth WHERE UserId = iUserId AND Enabled = TRUE AND ExpiredDate > current_timestamp();

IF oldApiKey IS NULL THEN
	INSERT INTO User_Auth(UserId,ApiKey,ApiSecret,Enabled,CreatedDate,ExpiredDate) values(
	iUserId,iApiKey,iApiSecret,TRUE,current_timestamp(),iExpiredDate);

	SET oID = last_insert_id();
ELSE
	SET oID = -1;
END IF;
COMMIT;
END$$

DELIMITER ;

#Create procedure sp_update_user_auth
DROP PROCEDURE IF EXISTS sp_update_user_auth;
DELIMITER $$
CREATE PROCEDURE sp_update_user_auth(
IN iID BIGINT(8),
IN iUserId BIGINT(8),
IN iApiKey NVARCHAR(50),
IN iApiSecret NVARCHAR(50),
IN iExpiredDate TIMESTAMP
)
BEGIN

UPDATE User_Auth SET ApiKey = iApiKey, ApiSecret = iApiSecret, ExpiredDate = iExpiredDate WHERE ID=iID AND UserId=iUserId;

END$$

DELIMITER ;

#Create procedure sp_get_user_auth
DROP PROCEDURE IF EXISTS sp_get_user_auth;
DELIMITER $$
CREATE PROCEDURE sp_get_user_auth(
IN iUserId BIGINT(8)
)
BEGIN

SELECT * FROM User_Auth WHERE UserId = iUserId AND Enabled = TRUE AND ExpiredDate > current_timestamp()
ORDER BY CreatedDate DESC LIMIT 1;

END$$

DELIMITER ;

#Update procedure sp_get_user_by_email_or_mobile_and_pwd
DROP PROCEDURE IF EXISTS sp_get_user_by_email_or_mobile_and_pwd;
DELIMITER $$
CREATE PROCEDURE sp_get_user_by_email_or_mobile_and_pwd(
IN iEmail NVARCHAR(50),
IN iMobile NVARCHAR(15),
IN iPassword NVARCHAR(50)
)
BEGIN

SELECT u.ID, u.Name, u.Email, u.Mobile, u.Company, ua.ApiKey, ua.ApiSecret
FROM User u
LEFT JOIN User_Auth ua
ON u.ID=ua.UserId
WHERE (u.Email=iEmail OR u.Mobile = iMobile) AND u.Password = iPassword AND u.Enabled = TRUE
AND (ua.ID IS NULL OR (ua.Enabled = TRUE AND ua.ExpiredDate > current_timestamp()));

END$$

DELIMITER ;