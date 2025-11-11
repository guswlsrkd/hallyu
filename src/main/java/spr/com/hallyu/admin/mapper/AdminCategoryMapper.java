package spr.com.hallyu.admin.mapper;

import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface AdminCategoryMapper {
    Map<String,Object> findOne(@Param("code") String code);
    List<Map<String,Object>> findTopList();
    List<Map<String,Object>> findChildren(@Param("parentCode") String parentCode);
    Integer findMaxSortOrder(@Param("parentCode") String parentCode);

    int insert(Map<String,Object> dto);
    int update(Map<String,Object> dto);
    
    Integer findDepth(@Param("code") String code);

    Integer nextSortOrder(@Param("parentCode") String parentCode);

    int insertChild(Map<String,Object> dto);
    int toggleVisible(Map<String,Object> p);

    int swapSortOrder(@Param("codeA") String codeA,
                      @Param("codeB") String codeB,
                      @Param("orderA") int orderA,
                      @Param("orderB") int orderB);

    int updateSortOrder(Map<String,Object> p);

    int delete(@Param("code") String code);
    List<String> findAllDescendants(@Param("rootCode") String rootCode);
}
