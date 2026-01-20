# 인기글 기능 구현 가이드 (부분 코드 변경)

이 문서는 '인기글' 카테고리를 추가하고, 제공된 공식에 따라 게시글을 정렬하는 기능의 구현 방법을 안내합니다.

## 1. `community/main.jsp` 수정: '인기글' 카테고리 추가

사이드바의 카테고리 목록에 '인기글'을 추가합니다.

**파일 경로**: `src/main/webapp/WEB-INF/views/community/main.jsp`

#### **변경 위치**
`<ul class="category-list">` 내부, `전체` 카테고리 바로 아래입니다.

#### **기존 코드 일부**
```jsp
<ul class="category-list">
    <!-- 전체 카테고리 -->
    <li class="category-item ${empty selectedCategoryId ? 'active' : ''}">
        <a href="<c:url value='/community'>
            ...
        </c:url>">전체</a>
    </li>
    <!-- DB에서 가져온 카테고리 목록 -->
    <c:forEach var="category" items="${categoryList}">
        <li class="category-item ${selectedCategoryId == category.categoryId ? 'active' : ''}">
            ...
        </li>
    </c:forEach>
</ul>
```

#### **추가할 코드**
아래 코드를 위의 **`<!-- 전체 카테고리 -->`** `<li>` 태그와 **`<!-- DB에서 가져온 카테고리 목록 -->`** `<c:forEach>` 태그 사이에 삽입하세요.

```jsp
<!-- 인기글 카테고리 추가 -->
<li class="category-item ${selectedCategoryId == 0 ? 'active' : ''}">
    <a href="<c:url value='/community'>
            <c:param name='categoryId' value='0'/>
            <c:if test='${not empty selectedDongCode}'>
                <c:param name='dongCode' value='${selectedDongCode}'/>
            </c:if>
            <c:if test='${not empty selectedGuName}'>
                <c:param name='guName' value='${selectedGuName}'/>
            </c:if>
        </c:url>">인기글</a>
</li>
```
---
## 2. `CommunityMapper.xml` 수정: 인기글 정렬 로직 추가

`selectPostList` 쿼리를 수정하여 `categoryId`가 `0`일 때 인기글 정렬 로직이 동작하도록 변경합니다.

**파일 경로**: `src/main/resources/com/gorani/vroom/community/CommunityMapper.xml`

#### **변경 위치**
기존의 `<select id="selectPostList" ...>` 태그 전체를 새로운 내용으로 교체합니다.

#### **대체될 기존 코드**
```xml
<select id = "selectPostList" resultType = "com.gorani.vroom.community.CommunityPostVO">
    SELECT
        c.post_id,
        c.title,
        c.content,
        c.view_count,
        c.like_count,
        c.created_at,
        c.updated_at,
        c.user_id,
        m.nickname,
        c.dong_code,
        d.dong_name,
        c.category_id,
        cc.category_name
    FROM COMMUNITY c
    LEFT JOIN COMMUNITY_CATEGORY cc ON c.category_id = cc.category_id
    LEFT JOIN MEMBERS m ON c.user_id = m.user_id
    LEFT JOIN LEGAL_DONG d ON c.dong_code = d.dong_code
    <where>
        c.deleted_at IS NULL
        <if test="dongCode != null and dongCode != ''">
            AND c.dong_code = #{dongCode}
        </if>
        <if test="categoryId != null">
            AND c.category_id = #{categoryId}
        </if>
        <if test="searchKeyword != null and searchKeyword != ''">
            AND (c.title LIKE CONCAT('%', #{searchKeyword}, '%')
            OR c.content LIKE CONCAT('%', #{searchKeyword}, '%'))
        </if>
    </where>
    ORDER BY c.created_at DESC
</select>
```

#### **적용할 새로운 코드**
위의 `<select>` 블록 전체를 아래의 `<select>` 블록으로 교체하세요. `categoryId` 값에 따라 분기 처리하는 `<choose>` 문이 핵심입니다.

```xml
<select id="selectPostList" resultType="com.gorani.vroom.community.CommunityPostVO">
    <choose>
        <!-- Case 1: 인기글 (categoryId = 0) -->
        <when test="categoryId != null and categoryId == 0">
            SELECT
                c.post_id,
                c.title,
                c.content,
                c.view_count,
                c.like_count,
                c.created_at,
                c.updated_at,
                c.user_id,
                m.nickname,
                c.dong_code,
                d.dong_name,
                c.category_id,
                cc.category_name
            FROM
                COMMUNITY c
            LEFT JOIN
                <!-- 댓글 수를 계산하는 서브쿼리 -->
                (SELECT post_id, COUNT(*) AS comment_count FROM COMMUNITY_COMMENT GROUP BY post_id) AS com_count ON c.post_id = com_count.post_id
            LEFT JOIN
                MEMBERS m ON c.user_id = m.user_id
            LEFT JOIN
                LEGAL_DONG d ON c.dong_code = d.dong_code
            LEFT JOIN
                COMMUNITY_CATEGORY cc ON c.category_id = cc.category_id
            <where>
                c.deleted_at IS NULL
                AND c.created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY) -- 최근 7일
                <if test="dongCode != null and dongCode != ''">
                    AND c.dong_code = #{dongCode}
                </if>
                <if test="searchKeyword != null and searchKeyword != ''">
                    AND (c.title LIKE CONCAT('%', #{searchKeyword}, '%') OR c.content LIKE CONCAT('%', #{searchKeyword}, '%'))
                </if>
            </where>
            ORDER BY
                (c.view_count * 1 + c.like_count * 10 + IFNULL(com_count.comment_count, 0) * 20) DESC, c.created_at DESC
        </when>

        <!-- Case 2: 일반 카테고리 및 전체 (기존 로직) -->
        <otherwise>
            SELECT
                c.post_id,
                c.title,
                c.content,
                c.view_count,
                c.like_count,
                c.created_at,
                c.updated_at,
                c.user_id,
                m.nickname,
                c.dong_code,
                d.dong_name,
                c.category_id,
                cc.category_name
            FROM
                COMMUNITY c
            LEFT JOIN
                COMMUNITY_CATEGORY cc ON c.category_id = cc.category_id
            LEFT JOIN
                MEMBERS m ON c.user_id = m.user_id
            LEFT JOIN
                LEGAL_DONG d ON c.dong_code = d.dong_code
            <where>
                c.deleted_at IS NULL
                <if test="dongCode != null and dongCode != ''">
                    AND c.dong_code = #{dongCode}
                </if>
                <if test="categoryId != null">
                    AND c.category_id = #{categoryId}
                </if>
                <if test="searchKeyword != null and searchKeyword != ''">
                    AND (c.title LIKE CONCAT('%', #{searchKeyword}, '%')
                    OR c.content LIKE CONCAT('%', #{searchKeyword}, '%'))
                </if>
            </where>
            ORDER BY
                c.created_at DESC
        </otherwise>
    </choose>
</select>
```
