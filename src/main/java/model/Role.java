package model;


public enum Role {
	KHACH_HANG("Khách hàng"),
	DOI_TAC("Đối tác"), 
	NHAN_VIEN("Nhân viên"), 
	ADMIN("Quản trị viên");
    private String roleName;

    Role(String roleName) {
        this.roleName = roleName;
    }

    public String roleName() {
        return roleName;
    }
    public static Role chuyenRoleTuChuoi(String chuoiRole) {
        if (chuoiRole == null) return null;
        for (Role role : values()) {
            if (role.roleName.equalsIgnoreCase(chuoiRole)) {
                return role;
            }
        }
        return null;
    }
}
