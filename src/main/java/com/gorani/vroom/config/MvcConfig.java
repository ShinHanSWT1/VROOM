package com.gorani.vroom.config;

import com.zaxxer.hikari.HikariDataSource;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.beans.factory.config.PropertyPlaceholderConfigurer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.core.io.ClassPathResource;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;
import org.springframework.web.servlet.config.annotation.*;

@Configuration
@MapperScan(basePackages = { "com.gorani.vroom" }, annotationClass = Mapper.class)
@ComponentScan(basePackages = { "com.gorani.vroom" })
@EnableWebMvc
@EnableTransactionManagement
public class MvcConfig implements WebMvcConfigurer {

    @Value("${db.driver}")
    private String driver;

    @Value("${db.url}")
    private String url;

    @Value("${db.username}")
    private String username;

    @Value("${db.password}")
    private String password;

    // 정적 리소스는 tomcat에서 처리하도록 핸들링
    public void configureDefaultServletHandling(DefaultServletHandlerConfigurer configurer) {
        configurer.enable();
    }

    // JSP 경로 (ViewResolver)
    @Override
    public void configureViewResolvers(ViewResolverRegistry registry) {
        registry.jsp("/WEB-INF/views/", ".jsp");
    }

    // CSS 경로
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Static 리소스 매핑 추가
        registry.addResourceHandler("/static/**")
                .addResourceLocations("/static/")
                .setCachePeriod(3600)
                .resourceChain(true);
    }

    // hikaricp
    @Bean
    @Primary
    public HikariDataSource dataSource() {
        HikariDataSource dataSource = new HikariDataSource();
        dataSource.setDriverClassName(driver);
        dataSource.setJdbcUrl(url);
        dataSource.setUsername(username);
        dataSource.setPassword(password);
        return dataSource;
    }

    // mybatis
    @Bean
    public SqlSessionFactory sqlSessionFactory() throws Exception {
        SqlSessionFactoryBean ssf = new SqlSessionFactoryBean();
        ssf.setDataSource(dataSource()); // 데이터소스객체 주입(setter방식)

        org.apache.ibatis.session.Configuration configuration = new org.apache.ibatis.session.Configuration();

        // 'login_id' (DB) -> 'loginId' (Java) 자동 매핑 옵션 활성화
        configuration.setMapUnderscoreToCamelCase(true);

        // 설정 객체를 SqlSessionFactoryBean에 주입
        ssf.setConfiguration(configuration);
        
        return ssf.getObject();
    }

    // 파일 업로드를 위한 객체, 이름은 무조건 multipartResolver
    @Bean
    public CommonsMultipartResolver multipartResolver() {
        CommonsMultipartResolver resolver = new CommonsMultipartResolver();
        resolver.setMaxUploadSize(5 * 1024 * 1024);
        resolver.setDefaultEncoding("utf-8");

        return resolver;
    }

    // 트랜잭션
    @Bean
    public PlatformTransactionManager transactionManager() {
        DataSourceTransactionManager dtm = new DataSourceTransactionManager(dataSource());

        return dtm;
    }


    @Bean
    public static PropertyPlaceholderConfigurer properties() {
        PropertyPlaceholderConfigurer config = new PropertyPlaceholderConfigurer();
        config.setLocation(new ClassPathResource("db.properties"));
        return config;
    }


}

