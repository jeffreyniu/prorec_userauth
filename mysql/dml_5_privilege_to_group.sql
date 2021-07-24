USE prorec;

#Add all privileges to admin group.
SELECT ID INTO @AdminGroupId FROM PrivilegeGroup WHERE Name = 'Admin';
CALL sp_add_all_privileges_to_group(@AdminGroupId);
SELECT @AdminGroupId;
