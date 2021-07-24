USE prorec;

#Get privilege id
SET @AdminPageUserId = -1;
CALL sp_add_privilege('AdminPage_User','User section in admin page',@AdminPageUserId);
SELECT @AdminPageUserId;

SET @AdminPageUserAuthId = -1;
CALL sp_add_privilege('AdminPage_UserAuth','User Auth section in admin page',@AdminPageUserAuthId);
SELECT @AdminPageUserAuthId;

SET @AdminPagePrivilegeGroupId = -1;
CALL sp_add_privilege('AdminPage_PrivilegeGroup','Privilege Group section in admin page',@AdminPagePrivilegeGroupId);
SELECT @AdminPagePrivilegeGroupId;

SET @AdminPagePrivilegeId = -1;
CALL sp_add_privilege('AdminPage_Privilege','Privilege section in admin page',@AdminPagePrivilegeId);
SELECT @AdminPagePrivilegeId;

SET @AdminPagePrivilegeDetailId = -1;
CALL sp_add_privilege('AdminPage_PrivilegeDetail','Privilege Detail section in admin page',@AdminPagePrivilegeDetailId);
SELECT @AdminPagePrivilegeDetailId;

SET @AdminPageUserPrivilegeGroupId = -1;
CALL sp_add_privilege('AdminPage_UserPrivilegeGroup','User_PrivilegeGroup section in admin page',@AdminPageUserPrivilegeGroupId);
SELECT @AdminPageUserPrivilegeGroupId;
