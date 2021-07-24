USE prorec;

-- Create table Url_Address
#Create table Url_Address
CREATE TABLE IF NOT EXISTS Url_Address (
    ID BIGINT(8) UNSIGNED PRIMARY KEY  AUTO_INCREMENT,
    UserId BIGINT(8) UNSIGNED NOT NULL,
    UrlAddr NVARCHAR(500) NOT NULL,
    CreatedDate TIMESTAMP,
    FOREIGN KEY(UserId) REFERENCES User(ID)
);

DELIMITER ;

#Create procedure sp_add_url_address
DROP PROCEDURE IF EXISTS sp_add_url_address;
DELIMITER $$
CREATE PROCEDURE sp_add_url_address(
IN iUserId BIGINT(8),
IN iUrlAddr NVARCHAR(500),
OUT oID BIGINT(8)
)
BEGIN
	INSERT INTO Url_Address(UserId,UrlAddr,CreatedDate) values(
	iUserId,iUrlAddr,current_timestamp());

	SET oID = last_insert_id();
END$$

DELIMITER ;

#Create procedure sp_get_url_address_by_id_and_userid
DROP PROCEDURE IF EXISTS sp_get_url_address_by_id_and_userid;
DELIMITER $$
CREATE PROCEDURE sp_get_url_address_by_id_and_userid(
IN iUserId BIGINT(8),
IN iID BIGINT(8),
IN ExpiredMins INT
)
BEGIN
	SELECT * FROM Url_Address WHERE ID=iID AND UserId=iUserId AND TIMESTAMPDIFF(MINUTE, NOW(), CreatedDate) < ExpiredMins;
END$$

DELIMITER ;