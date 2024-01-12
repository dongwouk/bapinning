<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>자유게시판</title>
<!-- <script>
	$(document).ready(function() {
		
	});
</script> -->
<script type="text/javascript">
	function writeui() {
		location.href = "write";
	}
	function gudan(v) {

		//event.preventDefault();
		document.querySelector("#team").value = v;
		v = $
		{
			pageDTO.team
		}
		alert(v);
	}
	function clear() {
		location.href = "list?team=0";
	}
</script>
<style>
a {
    text-decoration: none !important; 
}
</style>

</head>
<body>
	<jsp:include page="common/nav.jsp" flush="true" />

	<div class="container mt-5">
		<h2 class="text-center">밥이닝 자유게시판</h2>
		<div class="row">
			<div class="pt-2">
				<div class="container mt-2"
					style="font-family: 'KBO-Dia-Gothic_bold';">
					<ul class="nav list-unstyled d-flex">
						<li class="nav-item pt-1 mx-2"><a href="list?team=0"
							class="nav-link text-decoration-none text-dark table-link"
							data-target="all"> <img src="images/icon/baseball_icon.png"
								width="20" height="20"> 전체
						</a></li>
						<li class="nav-item mt-1 mx-2"><a href="list?team=1"
							class="nav-link text-decoration-none text-dark table-link"
							data-target="SSG"> <img
								src="//lgcxydabfbch3774324.cdn.ntruss.com/KBO_IMAGE/emblem/regular/2023/initial_SK.png"
								alt="SSG"> SSG
						</a></li>
						<li class="nav-item pt-1 mx-2"><a href="list?team=2"
							class="nav-link text-decoration-none text-dark table-link"
							data-target="키움"> <img
								src="//lgcxydabfbch3774324.cdn.ntruss.com/KBO_IMAGE/emblem/regular/2023/initial_WO.png"
								alt="키움"> 키움
						</a></li>
						<li class="nav-item pt-1 mx-2"><a href="list?team=3"
							class="nav-link text-decoration-none text-dark table-link"
							data-target="LG"> <img
								src="//lgcxydabfbch3774324.cdn.ntruss.com/KBO_IMAGE/emblem/regular/2023/initial_LG.png"
								alt="LG"> LG
						</a></li>
						<li class="nav-item pt-1 mx-2"><a href="list?team=4"
							class="nav-link text-decoration-none text-dark table-link"
							data-target="KT"> <img
								src="//lgcxydabfbch3774324.cdn.ntruss.com/KBO_IMAGE/emblem/regular/2023/initial_KT.png"
								alt="kt"> KT
						</a></li>
						<li class="nav-item pt-1 mx-2"><a href="list?team=5"
							class="nav-link text-decoration-none text-dark table-link"
							data-target="KIA"> <img
								src="//lgcxydabfbch3774324.cdn.ntruss.com/KBO_IMAGE/emblem/regular/2023/initial_HT.png"
								alt="KIA"> KIA
						</a></li>
						<li class="nav-item pt-1 mx-2"><a href="list?team=6"
							class="nav-link text-decoration-none text-dark table-link"
							data-target="NC"> <img
								src="//lgcxydabfbch3774324.cdn.ntruss.com/KBO_IMAGE/emblem/regular/2023/initial_NC.png"
								alt="NC"> NC
						</a></li>
						<li class="nav-item pt-1 mx-2"><a href="list?team=7"
							class="nav-link text-decoration-none text-dark table-link"
							data-target="삼성"> <img
								src="//lgcxydabfbch3774324.cdn.ntruss.com/KBO_IMAGE/emblem/regular/2023/initial_SS.png"
								alt="삼성"> 삼성
						</a></li>
						<li class="nav-item pt-1 mx-2"><a href="list?team=8"
							class="nav-link text-decoration-none text-dark table-link"
							data-target="롯데"> <img
								src="//lgcxydabfbch3774324.cdn.ntruss.com/KBO_IMAGE/emblem/regular/2023/initial_LT.png"
								alt="롯데"> 롯데
						</a></li>
						<li class="nav-item pt-1 mx-2"><a href="list?team=9"
							class="nav-link text-decoration-none text-dark table-link"
							data-target="두산"> <img
								src="//lgcxydabfbch3774324.cdn.ntruss.com/KBO_IMAGE/emblem/regular/2023/initial_OB.png"
								alt="두산"> 두산
						</a></li>
						<li class="nav-item pt-1 mx-2"><a href="list?team=10"
							class="nav-link text-decoration-none text-dark table-link"
							data-target="한화"> <img
								src="//lgcxydabfbch3774324.cdn.ntruss.com/KBO_IMAGE/emblem/regular/2023/initial_HH.png"
								alt="한화"> 한화
						</a></li>
					</ul>
				</div>
			</div>
		</div>


		<form action="list" id="searchForm" method="get" class="my-3">
			<select name="type">
				<option value="">검색 기준</option>
				<option value="T">제목</option>
				<option value="C">내용</option>
				<option value="W">작성자</option>
			</select> <input type="text" name="keyword" value="" /> <input type="hidden"
				name="team" value="${pageDTO.team}" />
			<button class="btn btn-primary btn-sm">검색</button>
		</form>

		<table class="table table-striped">
			<thead>
				<tr>
					<th>no</th>
					<th>제목</th>
					<th>작성자</th>
					<th>카테고리</th>
					<th>조회수</th>
					<th>작성일</th>
				</tr>
			</thead>
			<tbody>
				<c:set var="pageDTO" value="${pageDTO}" />
				<c:forEach var="board" items="${pageDTO.list}">
					<tr>
						<td>${board.board_num}</td>
						<td><a href="retrieve?no=${board.board_num}">${board.title}</a></td>
						<td>${board.userid}</td>
						<td><c:choose>
								<c:when test="${board.team_code == 1}"><img src="images/logo/SSG.png" width=auto height="30"></c:when>
								<c:when test="${board.team_code == 2}"><img src="images/logo/키움.png" width=auto height="30"></c:when>
								<c:when test="${board.team_code == 3}"><img src="images/logo/LG.png" width=auto height="30"></c:when>
								<c:when test="${board.team_code == 4}"><img src="images/logo/KT.png" width=auto height="30"></c:when>
								<c:when test="${board.team_code == 5}"><img src="images/logo/KIA.png" width=auto height="30"></c:when>
								<c:when test="${board.team_code == 6}"><img src="images/logo/NC.png" width=auto height="30"></c:when>
								<c:when test="${board.team_code == 7}"><img src="images/logo/삼성.png" width=auto height="30"></c:when>
								<c:when test="${board.team_code == 8}"><img src="images/logo/롯데.png" width=auto height="30"></c:when>
								<c:when test="${board.team_code == 9}"><img src="images/logo/두산.png" width=auto height="30"></c:when>
								<c:when test="${board.team_code == 10}"><img src="images/logo/한화.png" width=auto height="30"></c:when>
								<c:otherwise>
	
								</c:otherwise>
							</c:choose></td>
						<td>${board.count}</td>
						<td>${board.board_date}</td>
					</tr>
				</c:forEach>
			</tbody>
			<!--  page 번호 출력 -->
			<c:set var="perPage" value="${pageDTO.perPage}" />
			<c:set var="curPage" value="${pageDTO.curPage}" />
			<c:set var="totalCount" value="${pageDTO.totalCount}" />
			<c:set var="totalNum" value="${totalCount / perPage}" />
			<c:set var="startNum" value="${curPage-(curPage-1)%5}" />
			<c:set var="page" value="${(curPage == null)?1:curPage}" />
			<c:set var="type" value="${pageDTO.type}" />
			<c:set var="keyword" value="${pageDTO.keyword}" />
			<c:set var="team" value="${pageDTO.team}" />

			<c:if test="${totalCount%perPage != 0}">
				<c:set var="totalNum" value="${totalNum+1}" />
			</c:if>
			<tr>
				<td colspan="7"><c:if test="${startNum>1}">
						<a href="list?curPage=${startNum-1}" class="btn btn-next btn-primary mx-2">prev</a>
					</c:if> <c:if test="${startNum<=1}">
						<span class="btn btn-prev btn-primary mx-2" onclick="alert('no page');">prev</span>
					</c:if> <c:forEach var="l" begin="0" end="4">
						<c:if test="${startNum+l<=totalNum}">
							<c:if test="${curPage == startNum+l}">
								${startNum+l}
							</c:if>
							<c:if test="${curPage != startNum+l}">
								<a
									href="list?curPage=${startNum+l}&type=${type}&keyword=${keyword}&team=${team}">${startNum+l}</a>
							</c:if>
						</c:if>

					</c:forEach> <c:if test="${startNum+5<totalNum}">
						<a href="list?curPage=${startNum+5}" class="btn btn-next btn-primary mx-2">next</a>
					</c:if> <c:if test="${startNum+5>=totalNum}">
						<span class="btn btn-next btn-primary mx-2" onclick="alert('no page');">next</span>
					</c:if></td>

			</tr>
			<!--  page 번호 출력 -->
		</table>
		<button onclick="writeui()" class="btn btn-primary">글쓰기</button>
	</div>

</body>
</html>