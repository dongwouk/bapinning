<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>PlayerInfo</title>
<link href="css/player.css" rel="stylesheet" />
<style>
ul {
	list-style: none;
}

h3, h4 {
	color: rgb(0, 0, 0, 0.8) !important;
	text-shadow: 2px 2px 4px rgba(188, 188, 188);
	font-family: 'KBO-Dia-Gothic_bold' !important;
}

aside a {
	text-decoration: none !important;
	color: black !important;
}

.list-group-item:hover {
	background-color: rgb(199, 199, 199, 0.5) !important;
	font-color: black !important;
	border-radius: 5px;
}

.list-group .list-group-item {
	border: none;
	background-color: rgba(248, 249, 250, 0.5);
}

.list-group-item.active {
	color: white;
	background-color: rgb(199, 199, 199, 0.7) !important;
	border-color: #c5c5c5 !important;
	border-radius: 5px;
}

.category a {
	text-decoration: none !important;
	font-family: 'KBO-Dia-Gothic_bold';
	color: rgb(0, 0, 0, 0.6);
	font-size: 1.2rem;
	margin-left: 10px;
}

</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
	$(document).ready(function() {
		$('.brick-link').hover(function() {

			$(this).css('cursor', 'pointer');
		});

		$('.brick-link').click(function() {
			var player = $(this).data('player');
			console.log(player);

			var form = $('<form>', {
				action : 'playerInfo',
				method : 'GET'
			});

			var input = $('<input>', {
				type : 'hidden',
				name : 'player',
				value : player
			});

			form.append(input);
			form.appendTo('body').submit();
		});

		$("a:contains('전체')").click(function() {
			requestFilter('전체');
		});

		// '투수'를 클릭했을 때
		$("a:contains('투수')").click(function() {
			requestFilter('투수');
		});

		// '포수'를 클릭했을 때
		$("a:contains('포수')").click(function() {
			requestFilter('포수');
		});

		// '외야수'를 클릭했을 때
		$("a:contains('외야수')").click(function() {
			requestFilter('외야수');
		});

		// '내야수'를 클릭했을 때
		$("a:contains('내야수')").click(function() {
			requestFilter('내야수');
		});
	});
</script>
<body>
	<jsp:include page="../common/nav.jsp" flush="true" />
	<div class="container mt-5">
		<div class="row">
			<aside class="col-md-3 me-1" style="width: 20%;">
				<hr style="border: 2px solid #000;">
				<ul class="list-group">
					<li class="list-group-item"><a href="schedule">경기일정</a></li>
					<li class="list-group-item"><a href="highlight">하이라이트</a></li>
					<li class="list-group-item"><a href="rank">팀 순위</a></li>
					<li class="list-group-item active"><a href="players">선수 정보</a></li>
				</ul>
			</aside>
			<div class="input-form-background col-md-9"
				style="margin: 0px !important;">
				<div class="input-form">
					<h3 class="mb-2 mx-5" style="font-family: 'KBO-Dia-Gothic_bold'">선수
						엔트리</h3>
					<div class="category" style="float: right; clear: right;">
						<a href="players">전체</a> 
						<a href="players?position=투수">투수</a> 
						<a href="players?position=포수">포수</a> 
						<a href="players?position=외야수">외야수</a> 
						<a href="players?position=내야수">내야수</a>
					</div>
					<br>

					<div class="player_card freewall">
						<ul class="all">
							<c:forEach var="dto" items="${list}" varStatus="loop">
								<c:set var="id" value="${loop.index + 1}" />
								<c:set var="delay" value="${loop.index + 1}" />
								<c:if test="${loop.index % 3 == 0}">
									<div class="row">
								</c:if>
								<div class="col-md-4">
									<li class="brick pitcher" id="${id}" data-delay="${delay}"
										data-height="260" data-width="300" data-state="start"
										style="width: 350.33px; height: 268.44px; display: block;"><a
										id="teamMemberDetail" class="brick-link" href="#"
										data-player="${dto.player}">
											<div class="bg"></div>
											<div class="txt_wrap">
												<p class="number">${dto.player_no}</p>
												<h3 class="player">${dto.player}</h3>
												<p style="font-size:0.8rem">${dto.name}</p>
												<p class="position">${dto.position}</p>
											</div>
											<div class="img_wrap">
												<img src="${dto.image}" alt="">
											</div>
									</a></li>
								</div>
								<c:if test="${loop.index % 3 == 2 or loop.last}">
					</div>
					</c:if>
					</c:forEach>
					</ul>
				</div>
			</div>
		</div>
	</div>
	</div>
</body>

</html>