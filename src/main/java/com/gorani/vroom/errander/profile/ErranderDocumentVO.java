package com.gorani.vroom.errander.profile;

import lombok.Data;

@Data
public class ErranderDocumentVO {
    private String documentType; // enum('IDCARD', 'PASSPORT', 'ACCOUNT', 'DRIVER_LICENSE', 'ETC')
    private String originalName; // "my_passport.jpg"
    private String filePath;

    public ErranderDocumentVO(String documentType, String originalName, String filePath) {
        this.documentType = documentType;
        this.originalName = originalName;
        this.filePath = filePath;
    }
}