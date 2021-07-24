USE prorec;

-- PrivilegeDetail
#Create table PrivilegeDetail
CREATE TABLE IF NOT EXISTS PrivilegeDetail (
    GroupID BIGINT(8) UNSIGNED,
    PrivilegeID BIGINT(8) UNSIGNED,
    CanLoad BOOLEAN,
    CanCreate BOOLEAN,
    CanUpdate BOOLEAN,
    CanDelete BOOLEAN,
    FOREIGN KEY(GroupID) REFERENCES PrivilegeGroup(ID),
    FOREIGN KEY(PrivilegeID) REFERENCES Privilege(ID),
    PRIMARY KEY(GroupID,PrivilegeID)
);

DELIMITER ;

#Create procedure sp_add_privilegedetail
DROP PROCEDURE IF EXISTS sp_add_privilegedetail;
DELIMITER $$
CREATE PROCEDURE sp_add_privilegedetail(
    IN iGroupID BIGINT(8),
    IN iPrivilegeID BIGINT(8),
    IN iCanLoad BOOLEAN,
    IN iCanCreate BOOLEAN,
    IN iCanUpdate BOOLEAN,
    IN iCanDelete BOOLEAN
)
BEGIN
    DECLARE oldPrivilegeID BIGINT(8);
    START TRANSACTION;

    SELECT PrivilegeID INTO oldPrivilegeID FROM PrivilegeDetail WHERE GroupID = iGroupID AND PrivilegeID = iPrivilegeID;

    IF oldPrivilegeID IS NULL THEN
        INSERT INTO PrivilegeDetail(GroupID,PrivilegeID,CanLoad,CanCreate,CanUpdate,CanDelete) values(
	    iGroupID, iPrivilegeID, iCanLoad, iCanCreate, iCanUpdate, iCanDelete);
    END IF;
    COMMIT;
END$$

DELIMITER ;

#Create procedure sp_add_all_privileges_to_group
DROP PROCEDURE IF EXISTS sp_add_all_privileges_to_group;
DELIMITER $$
CREATE PROCEDURE sp_add_all_privileges_to_group(
    IN iGroupID BIGINT(8)
)
BEGIN
    DECLARE endLoop INT DEFAULT 0;
    DECLARE privilegeID BIGINT(8);
    
    DECLARE privCursor CURSOR FOR SELECT ID FROM Privilege;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET endLoop = 1;

    START TRANSACTION;

    OPEN privCursor;
        FETCH privCursor INTO privilegeID;
        WHILE endLoop <> 1 DO
            CALL sp_add_privilegedetail(iGroupID, privilegeID, FALSE, FALSE, FALSE, FALSE);
            FETCH privCursor INTO privilegeID;
        END WHILE;

    CLOSE privCursor;
    
    COMMIT;
END$$

DELIMITER ;

#Create procedure sp_get_privilegedetail
DROP PROCEDURE IF EXISTS sp_get_privilegedetail;
DELIMITER $$
CREATE PROCEDURE sp_get_privilegedetail(
    IN iGroupID BIGINT(8),
    IN iPrivilegeID BIGINT(8)
)
BEGIN

SELECT pd.GroupID, pg.Name GroupName, pd.PrivilegeID, p.Name PrivilegeName,pd.CanLoad, pd.CanCreate, pd.CanUpdate, pd.CanDelete
FROM PrivilegeDetail pd
INNER JOIN PrivilegeGroup pg ON pd.GroupID=pg.ID
INNER JOIN Privilege p ON pd.PrivilegeID=p.ID
WHERE pd.GroupID = iGroupID AND pd.PrivilegeID = iPrivilegeID;

END$$

DELIMITER ;

#Create procedure sp_get_privilegedetails
DROP PROCEDURE IF EXISTS sp_get_privilegedetails;
DELIMITER $$
CREATE PROCEDURE sp_get_privilegedetails()
BEGIN

SELECT pd.GroupID, pg.Name GroupName, pd.PrivilegeID, p.Name PrivilegeName,pd.CanLoad, pd.CanCreate, pd.CanUpdate, pd.CanDelete
FROM PrivilegeDetail pd
INNER JOIN PrivilegeGroup pg ON pd.GroupID=pg.ID
INNER JOIN Privilege p ON pd.PrivilegeID=p.ID;

END$$

DELIMITER ;

#Create procedure sp_get_privilegedetail_by_privilegeid
DROP PROCEDURE IF EXISTS sp_get_privilegedetail_by_privilegeid;
DELIMITER $$
CREATE PROCEDURE sp_get_privilegedetail_by_privilegeid(
    IN iPrivilegeID BIGINT(8)
)
BEGIN

SELECT pd.GroupID, pg.Name GroupName, pd.PrivilegeID, p.Name PrivilegeName,pd.CanLoad, pd.CanCreate, pd.CanUpdate, pd.CanDelete
FROM PrivilegeDetail pd
INNER JOIN PrivilegeGroup pg ON pd.GroupID=pg.ID
INNER JOIN Privilege p ON pd.PrivilegeID=p.ID
WHERE pd.PrivilegeID = iPrivilegeID;

END$$

DELIMITER ;

#Create procedure sp_get_privilegedetail_by_userid
DROP PROCEDURE IF EXISTS sp_get_privilegedetail_by_userid;
DELIMITER $$
CREATE PROCEDURE sp_get_privilegedetail_by_userid(
    IN iUserID BIGINT(8)
)
BEGIN

SELECT u.ID UserID, u.Name UserName, pd.GroupID, pg.Name GroupName, pd.PrivilegeID, p.Name PrivilegeName,pd.CanLoad, pd.CanCreate, pd.CanUpdate, pd.CanDelete
FROM PrivilegeDetail pd
INNER JOIN PrivilegeGroup pg ON pd.GroupID=pg.ID
INNER JOIN Privilege p ON pd.PrivilegeID=p.ID
INNER JOIN User_PrivilegeGroup up ON up.GroupID = pd.GroupID
INNER JOIN User u ON u.ID = up.UserId 
WHERE u.ID = iUserID;

END$$

DELIMITER ;

#Create procedure sp_get_privilegedetail_by_groupid
DROP PROCEDURE IF EXISTS sp_get_privilegedetail_by_groupid;
DELIMITER $$
CREATE PROCEDURE sp_get_privilegedetail_by_groupid(
    IN iGroupID BIGINT(8)
)
BEGIN

SELECT pd.GroupID, pg.Name GroupName, pd.PrivilegeID, p.Name PrivilegeName,pd.CanLoad, pd.CanCreate, pd.CanUpdate, pd.CanDelete
FROM PrivilegeDetail pd
INNER JOIN PrivilegeGroup pg ON pd.GroupID=pg.ID
INNER JOIN Privilege p ON pd.PrivilegeID=p.ID
WHERE pd.GroupID = iGroupID;

END$$

DELIMITER ;

#Create procedure sp_update_privilegedetail
DROP PROCEDURE IF EXISTS sp_update_privilegedetail;
DELIMITER $$
CREATE PROCEDURE sp_update_privilegedetail(
    IN iGroupID BIGINT(8),
    IN iPrivilegeID BIGINT(8),
    IN iCanLoad BOOLEAN,
    IN iCanCreate BOOLEAN,
    IN iCanUpdate BOOLEAN,
    IN iCanDelete BOOLEAN
)
BEGIN

UPDATE PrivilegeDetail SET CanLoad=iCanLoad, CanCreate=iCanCreate, CanUpdate=iCanUpdate, CanDelete=iCanDelete WHERE GroupID = iGroupID AND PrivilegeID = iPrivilegeID;

END$$

DELIMITER ;

#Create procedure sp_delete_privilegedetail
DROP PROCEDURE IF EXISTS sp_delete_privilegedetail;
DELIMITER $$
CREATE PROCEDURE sp_delete_privilegedetail(
    IN iGroupID BIGINT(8),
    IN iPrivilegeID BIGINT(8)
)
BEGIN

DELETE FROM PrivilegeDetail WHERE GroupID = iGroupID AND PrivilegeID = iPrivilegeID;

END$$

DELIMITER ;