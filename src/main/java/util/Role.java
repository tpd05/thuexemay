package util;

public enum Role {
    DOI_TAC("DOI_TAC"),
    KHACH_HANG("KHACH_HANG"),
    ADMIN("ADMIN");

    private final String giaTri;

    Role(String giaTri) {
        this.giaTri = giaTri;
    }

    public String layGiaTri() {
        return giaTri;
    }

    public static Role chuyenRoleTuChuoi(String chuoiRole) {
        if (chuoiRole == null) return null;
        for (Role role : values()) {
            if (role.giaTri.equalsIgnoreCase(chuoiRole)) {
                return role;
            }
        }
        return null;
    }
}