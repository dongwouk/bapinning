<%@page import="com.app.controller.ReviewController"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>숙소 리뷰</title>
<link rel="icon" type="image/png" sizes="32x32"
	href="images/icon/favicon-32x32.png">
<link href="css/review.css" rel="stylesheet" />
</head>
<body>
	<jsp:include page="../common/nav.jsp" flush="true" />
	
	<form id="myform" action="lodReviewUpdate" method="get">
	    <input type="hidden" name="lodging_id" value="${lodReviewRetrieve.lodging_id}">
	    <input type="hidden" name="review_id" value="${lodReviewRetrieve.review_id}"> 
<%-- 
	    <input type="hidden" name="review_content" value="${lodReviewRetrieve.review_content}"> 
	    <input type="text" name="review_id" value="${lodReviewRetrieve.user_id}"> 
 --%>
		<div class="myform">
			<div class="container">
	 	 		<div name="rating" id="rating" value="${lodReviewRetrieve.rating}">
			    <fieldset style="text-align: center">
					  <legend style="font-family: 'KBO-Dia-Gothic_bold'">별점</legend>
			        <input type="radio" name="rating" value="5" id="rate5" disabled><label for="rate5">⭐</label>
			        <input type="radio" name="rating" value="4" id="rate4" disabled><label for="rate4">⭐</label>
			        <input type="radio" name="rating" value="3" id="rate3" disabled><label for="rate3">⭐</label>
			        <input type="radio" name="rating" value="2" id="rate2" disabled><label for="rate2">⭐</label>
			        <input type="radio" name="rating" value="1" id="rate1" disabled><label for="rate1">⭐</label>
			     </fieldset>
	 	 		</div>
			</div>
			<div style="float: right">
				<span style="font-weight: bold;">${lodReviewRetrieve.nickname}</span> &nbsp;
				<c:choose>
				    <c:when test="${lodReviewRetrieve.created_date eq lodReviewRetrieve.modified_date}">
				        <span>${lodReviewRetrieve.created_date}</span>&nbsp;
				    </c:when>
				    <c:otherwise>
				        <span>${lodReviewRetrieve.modified_date} (수정됨)</span>&nbsp;
				    </c:otherwise>
				</c:choose>
				<span><a href="lod_like_cnt?review_id=${dto.review_id}" class="btn btn-primary btn-sm"
				onclick="return false;"> <!-- 클릭막아둠 -->
						<img src="images/icon/thumb2_icon.png" width=15 height=15> ${lodReviewRetrieve.like_cnt}</a>
				</span>
			</div>
			<div class="container">
				<textarea class="col-auto form-control" type="text" id="review_content" name="review_content"
						  style="font-family: 'KBO-Dia-Gothic_light'" 
						  placeholder="${lodReviewRetrieve.review_content}" readonly></textarea>
			</div>
	
			<c:choose>
			    <c:when test="${!empty urls}">
					  <div class="imgs_wrap">
			        <c:forEach var="url" items="${urls}">
			            <div style="text-align:center; display: inline-block;">
			            	 <a href="#" onclick="openModal('${url}')">
			                <img id="img" class="mb-2" src="${url}" alt="이미지">
			               </a>
			            </div>
			        </c:forEach>
							<div id="myModal" class="modal">
							    <span class="close" onclick="closeModal()">&times;</span>
							    <img id="modalImg" src="" alt="모달 이미지">
							</div>
						</div>
			    </c:when>
			</c:choose>
			
				<div class="d-grid gap-2 col-6 mx-auto">
				  <button class="btn btn-primary" type="submit" id="editBtn">수정</button>
					<button class="btn btn-primary" type="button" id="deleteBtn" onclick="del('${lodReviewRetrieve.review_id}')">삭제</button>			
				  <button class="btn btn-primary" type="button" id="cancelBtn" onclick="cancel('${lodReviewRetrieve.lodging_id}')">목록보기</button>
				</div>
		</div>
	</form>	

<script src="js/review.js"></script>
<script type="text/javascript">
	//별점 출력
	var ratingValue = ${lodReviewRetrieve.rating};
	
	var radioButtons = document.getElementsByName("rating");
	for (var i = 0; i < radioButtons.length; i++) {
	  if (parseInt(radioButtons[i].value) === ratingValue) {
	    radioButtons[i].checked = true;
	  }
	}

	//삭제 버튼
	function del(review_id) {
	    var shouldDelete = confirm("리뷰를 삭제하시겠습니까?");
	    if (shouldDelete) {
	    	window.location.href = "lodReviewDelete?review_id=" + review_id;
	    }
	}
	
	//목록보기 버튼
	function cancel(lodging_id){
		window.location.href = "l_reviewList?lodging_id=" + lodging_id;
	}

	// 현재 사용자와 작성자의 아이디를 비교하여 버튼 표시 여부 결정
	var currentUserID = "${login.userid}";
	var authorID = "${lodReviewRetrieve.user_id}";

	var editBtn = document.getElementById("editBtn");
	var deleteBtn = document.getElementById("deleteBtn");

	if (currentUserID === authorID) {
		editBtn.style.display = "block";
		deleteBtn.style.display = "block";
	} else {
		editBtn.style.display = "none";
		deleteBtn.style.display = "none";
	}
</script>
	
</body>
</html>
