package com.gorani.vroom.errand.post;

public class CategoryVO {

    private Long id;    // CATEGORIES.id
    private String name; // CATEGORIES.name
    private String defaultImageUrl; // CATEGORIES.default_image_url

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDefaultImageUrl() {
        return defaultImageUrl;
    }

    public void setDefaultImageUrl(String defaultImageUrl) {
        this.defaultImageUrl = defaultImageUrl;
    }
}
