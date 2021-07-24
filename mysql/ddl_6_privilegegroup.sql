USE prorec;

-- PrivilegeGroup
#Create table PrivilegeGroup
CREATE TABLE IF NOT EXISTS PrivilegeGroup (
    ID BIGINT(8) UNSIGNED PRIMARY KEY  AUTO_INCREMENT,
    Name NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(500)
);

DELIMITER ;

#Create procedure sp_add_privilegegroup
DROP PROCEDURE IF EXISTS sp_add_privilegegroup;
DELIMITER $$
CREATE PROCEDURE sp_add_privilegegroup(
    IN iName NVARCHAR(50),
    IN iDescription NVARCHAR(500),
    OUT oID BIGINT(8)
)
BEGIN
    DECLARE oldName NVARCHAR(50);

    START TRANSACTION;

    SELECT Name INTO oldName FROM PrivilegeGroup WHERE Name = iName;

    IF oldName IS NULL THEN
        INSERT INTO PrivilegeGroup(Name,Description) values(iName,iDescription);
	    SET oID = last_insert_id();
    ELSE
        SET oID = -1;
    END IF;
    COMMIT;
END$$

DELIMITER ;

#Create procedure sp_get_privilegegroup
DROP PROCEDURE IF EXISTS sp_get_privilegegroup;
DELIMITER $$
CREATE PROCEDURE sp_get_privilegegroup(
IN iID BIGINT(8)
)
BEGIN

SELECT * FROM PrivilegeGroup WHERE ID = iID;

END$$

DELIMITER ;

#Create procedure sp_get_privilegegroups
DROP PROCEDURE IF EXISTS sp_get_privilegegroups;
DELIMITER $$
CREATE PROCEDURE sp_get_privilegegroups()
BEGIN

SELECT * FROM PrivilegeGroup;

END$$

DELIMITER ;

#Create procedure sp_update_privilegegroup
DROP PROCEDURE IF EXISTS sp_update_privilegegroup;
DELIMITER $$
CREATE PROCEDURE sp_update_privilegegroup(
    IN iName NVARCHAR(50),
    IN iDescription NVARCHAR(500),
    IN iID BIGINT(8)
)
BEGIN

UPDATE PrivilegeGroup SET Name=iName,Description=iDescription WHERE ID = iID;

END$$

DELIMITER ;