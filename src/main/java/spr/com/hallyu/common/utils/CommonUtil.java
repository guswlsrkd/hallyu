package spr.com.hallyu.common.utils;

import java.util.HashMap;

//import com.google.protobuf.Method;

public class CommonUtil {
	public static HashMap<String, Object> getPageInfo(HashMap<String, Object> paramMap, String boardId){
		int bbsPageCnt = 10;		
		if(paramMap.get("pageCnt") == null) {
			if(boardId.equals("board_010")) bbsPageCnt = 20;
		}else {
			bbsPageCnt =  Integer.parseInt((String.valueOf(paramMap.get("pageCnt"))));
		}
		try {
			int pageLimit = 0;
			if(boardId.equals("board_004") || boardId.equals("board_005") || boardId.equals("board_003")) {
				pageLimit = !"".equals(paramMap.get("pageLimit")) && paramMap.get("pageLimit") != null ?  Integer.parseInt(paramMap.get("pageLimit").toString()) : 8;
			}else {
				pageLimit = !"".equals(paramMap.get("pageLimit")) && paramMap.get("pageLimit") != null ?  Integer.parseInt(paramMap.get("pageLimit").toString()) : bbsPageCnt;
			}
			int listCnt = Integer.parseInt(paramMap.get("listCnt").toString());
			int currentPage = !"".equals(paramMap.get("currentPage")) && paramMap.get("currentPage") != null ?  Integer.parseInt(paramMap.get("currentPage").toString()) : 1;
			int maxPage = (int) Math.ceil((double)listCnt/(double)pageLimit);
			// 페이지 보정
			if (currentPage > maxPage) currentPage = maxPage;
			int pageOffset = !"".equals(paramMap.get("currentPage")) && paramMap.get("currentPage") != null ? pageLimit*(currentPage-1) : 0;
	
			//페이징 부분에 한번에 보여줄 페이지갯수 (10페이지 이상 넘어갈 경우 너무 길어져서 처리함)
			int pageCnt = !"".equals(paramMap.get("pageCnt")) && paramMap.get("pageCnt") != null ?  Integer.parseInt(paramMap.get("pageCnt").toString()) : bbsPageCnt;
			int leastPage = (((int)(currentPage - 1) / pageCnt) * pageCnt) + 1; //페이징에 보여지는 최소페이지값
			int greatestPage = (((int)(currentPage - 1) / pageCnt) * pageCnt) + pageCnt; //페이징에 보여지는 최대페이지값
			greatestPage = Math.min(greatestPage, maxPage); //페이징에 보여지는 최대페이지값
	
	
			//paramMap.put("listCnt", listCnt);
	//		paramMap.put("page", page);
			paramMap.put("maxPage", maxPage);
			paramMap.put("currentPage", currentPage);
			paramMap.put("pageLimit", pageLimit);
			paramMap.put("pageOffset", pageOffset);
			paramMap.put("pageCnt", pageCnt);
			paramMap.put("leastPage", leastPage);
			paramMap.put("greatestPage", greatestPage);
			/*System.out.println("listCnt : "+listCnt);
			System.out.println("maxPage : "+maxPage);
			System.out.println("currentPage : "+currentPage);
			System.out.println("pageLimit : "+pageLimit);
			System.out.println("pageOffset : "+pageOffset);
			System.out.println("pageCnt : "+pageCnt);
			//System.out.println("bbsPageCnt : "+bbsPageCnt);
			System.out.println("leastPage : "+leastPage);
			System.out.println("greatestPage : "+greatestPage);*/
		}catch(NumberFormatException e) {
			e.printStackTrace();
		}catch(Exception e) {
			e.printStackTrace();
		}

		return paramMap;
	}
	
	public static HashMap<String, Object> getPageInfo(HashMap<String, Object> paramMap){
		try {
		int pageLimit = 0;
		pageLimit = !"".equals(paramMap.get("pageLimit")) && paramMap.get("pageLimit") != null ?  Integer.parseInt(paramMap.get("pageLimit").toString()) : 10;
		
		int listCnt = Integer.parseInt(paramMap.get("listCnt").toString());
		int currentPage = !"".equals(paramMap.get("currentPage")) && paramMap.get("currentPage") != null ?  Integer.parseInt(paramMap.get("currentPage").toString()) : 1;
		int maxPage = (int) Math.ceil((double)listCnt/(double)pageLimit);
		int pageOffset = !"".equals(paramMap.get("currentPage")) && paramMap.get("currentPage") != null ? pageLimit*(currentPage-1) : 0;

		//페이징 부분에 한번에 보여줄 페이지갯수 (10페이지 이상 넘어갈 경우 너무 길어져서 처리함)
		int pageCnt = !"".equals(paramMap.get("pageCnt")) && paramMap.get("pageCnt") != null ?  Integer.parseInt(paramMap.get("pageCnt").toString()) : 10;
		int leastPage = (((int)(currentPage - 1) / pageCnt) * pageCnt) + 1; //페이징에 보여지는 최소페이지값
		int greatestPage = (((int)(currentPage - 1) / pageCnt) * pageCnt) + pageCnt; //페이징에 보여지는 최대페이지값
		greatestPage = Math.min(greatestPage, maxPage); //페이징에 보여지는 최대페이지값

		paramMap.put("listCnt", listCnt);
//		paramMap.put("page", page);
		paramMap.put("maxPage", maxPage);
		paramMap.put("currentPage", currentPage);
		paramMap.put("pageLimit", pageLimit);
		paramMap.put("pageOffset", pageOffset);
		paramMap.put("pageCnt", pageCnt);
		paramMap.put("leastPage", leastPage);
		paramMap.put("greatestPage", greatestPage);
		}catch(NumberFormatException e) {
			e.printStackTrace();
		}catch(Exception e) {
			e.printStackTrace();
		}

		return paramMap;
	}
}
