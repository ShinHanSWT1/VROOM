package com.gorani.vroom.common.util;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
@PropertySource("classpath:application.properties")
public class S3UploadService {

    private final AmazonS3 amazonS3;

    @Value("${cloud.aws.s3.bucket}")
    private String bucket;

    /**
     * S3에 파일 업로드 후 URL 반환
     * @param file 업로드할 파일
     * @param dirName 저장할 디렉토리명 (예: "errand", "profile", "community")
     * @return S3 파일 URL
     */
    public String upload(MultipartFile file, String dirName) throws IOException {
        // 고유 파일명 생성
        String originalFilename = file.getOriginalFilename();
        String extension = "";
        if (originalFilename != null && originalFilename.contains(".")) {
            extension = originalFilename.substring(originalFilename.lastIndexOf("."));
        }
        String savedFileName = dirName + "/" + UUID.randomUUID() + extension;

        // 메타데이터 설정
        ObjectMetadata metadata = new ObjectMetadata();
        metadata.setContentType(file.getContentType());
        metadata.setContentLength(file.getSize());

        // S3에 업로드 (ACL 설정 제거 - 버킷 정책을 따름)
        amazonS3.putObject(new PutObjectRequest(bucket, savedFileName, file.getInputStream(), metadata));

        // 업로드된 파일 URL 반환
        return amazonS3.getUrl(bucket, savedFileName).toString();
    }

    /**
     * S3에서 파일 삭제
     * @param fileUrl 삭제할 파일의 전체 URL
     */
    public void delete(String fileUrl) {
        try {
            // URL에서 파일 키 추출
            String fileKey = fileUrl.substring(fileUrl.indexOf(bucket) + bucket.length() + 1);
            amazonS3.deleteObject(bucket, fileKey);
            log.info("S3 파일 삭제 완료: {}", fileKey);
        } catch (Exception e) {
            log.error("S3 파일 삭제 실패: {}", e.getMessage());
        }
    }
}
