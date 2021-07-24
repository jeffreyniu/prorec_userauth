USE prorec;

-- Privilege
#Create table Privilege
CREATE TABLE IF NOT EXISTS Privilege (
    ID BIGINT(8) UNSIGNED PRIMARY KEY  AUTO_INCREMENT,
    Name NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(500)
);

DELIMITER ;

#Create procedure sp_add_privilege
DROP PROCEDURE IF EXISTS sp_add_privilege;
DELIMITER $$
CREATE PROCEDURE sp_add_privilege(
    IN iName NVARCHAR(50),
    IN iDescription NVARCHAR(500),
    OUT oID BIGINT(8)
)
BEGIN
    DECLARE oldName NVARCHAR(50);
    START TRANSACTION;

    SELECT Name INTO oldName FROM Privilege WHERE Name = iName;

    IF oldName IS NULL THEN
        INSERT INTO Privilege(Name,Description) values(iName,iDescription);
	    SET oID = last_insert_id();
    ELSE
        SET oID = -1;
    END IF;
    COMMIT;
END$$

DELIMITER ;

#Create procedure sp_get_privilege
DROP PROCEDURE IF EXISTS sp_get_privilege;
DELIMITER $$
CREATE PROCEDURE sp_get_privilege(
IN iID BIGINT(8)
)
BEGIN

SELECT * FROM Privilege WHERE ID = iID;

END$$

DELIMITER ;

#Create procedure sp_get_privileges
DROP PROCEDURE IF EXISTS sp_get_privileges;
DELIMITER $$
CREATE PROCEDURE sp_get_privileges()
BEGIN

SELECT * FROM Privilege;

END$$

DELIMITER ;

#Create procedure sp_update_privilege
DROP PROCEDURE IF EXISTS sp_update_privilege;
DELIMITER $$
CREATE PROCEDURE sp_update_privilege(
    IN iName NVARCHAR(50),
    IN iDescription NVARCHAR(500),
    IN iID BIGINT(8)
)
BEGIN

UPDATE Privilege SET Name=iName, Description=iDescription WHERE ID = iID;

END$$

DELIMITER ;