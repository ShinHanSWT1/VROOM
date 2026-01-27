package com.gorani.vroom.config;

import com.gorani.vroom.common.util.AdminLoginInterceptor;
import org.apache.ibatis.annotations.Mapper;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;
import org.springframework.web.servlet.config.annotation.*;

@Configuration
@MapperScan(basePackages = {"com.gorani.vroom"}, annotationClass = Mapper.class)
@ComponentScan(basePackages = {"com.gorani.vroom"})
@EnableWebMvc
@EnableTransactionManagement
public class MvcConfig implements WebMvcConfigurer {

    // 업로드 경로
    public static final String PROFILE_UPLOAD_PATH = "C:/uploads/profile/";
    public static final String ERRAND_UPLOAD_PATH  = "C:/uploads/errand/";
    public static final String COMMUNITY_UPLOAD_PATH = "C:/uploads/community/";
    public static final String ERRANDER_DOC_UPLOAD_PATH = "C:/uploads/erranderDocs/";

    // View Resolver (JSP)
    @Override
    public void configureViewResolvers(ViewResolverRegistry registry) {
        registry.jsp("/WEB-INF/views/", ".jsp");
    }

    // Static Resource
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {

        // 정적 리소스
        registry.addResourceHandler("/static/**")
                .addResourceLocations("/static/")
                .setCachePeriod(3600);

        // 프로필 이미지
        registry.addResourceHandler("/uploads/profile/**")
                .addResourceLocations("file:/" + PROFILE_UPLOAD_PATH);

        // 심부름 이미지
        registry.addResourceHandler("/uploads/errand/**")
                .addResourceLocations("file:/" + ERRAND_UPLOAD_PATH);

        // 커뮤니티 이미지 (외부 경로 매핑)
        registry.addResourceHandler("/uploads/community/**")
                .addResourceLocations("file:/" + COMMUNITY_UPLOAD_PATH);

        // 부름이 서류 이미지
        registry.addResourceHandler("/uploads/erranderDocs/**")
                .addResourceLocations("file:/" + ERRANDER_DOC_UPLOAD_PATH);
    }

    // Interceptor
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new AdminLoginInterceptor())
                .addPathPatterns("/admin/**")
                .excludePathPatterns("/admin/login", "/admin/auth/**");
    }

    // Multipart Resolver
    @Override
    public void configureDefaultServletHandling(DefaultServletHandlerConfigurer configurer) {
        configurer.enable();
    }

    @Bean(name = "multipartResolver")
    public CommonsMultipartResolver multipartResolver() {
        CommonsMultipartResolver resolver = new CommonsMultipartResolver();
        resolver.setMaxUploadSize(30 * 1024 * 1024); // 30MB
        resolver.setMaxUploadSizePerFile(10 * 1024 * 1024); // 10MB per file
        resolver.setDefaultEncoding("utf-8");
        return resolver;
    }
}
