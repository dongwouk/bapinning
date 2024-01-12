<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="css/sidebar.css" rel="stylesheet" />
<title>수원 KT위즈파크 주변 맛집 지도</title>
</head>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<body>
 	<jsp:include page="../common/nav.jsp" flush="true"/> 
	<div class="sidebar" id="sidebar">
		<!-- 가게 정보 띄우기  -->
		<form action="r_reviewList" method="get">
			<input type="hidden" id="res_id" name="res_id">
			<div class="card mt-5">
				<div id="res_image"></div>
				<div class="card-body">
					<h1 class="card-title mt-3 mb-4" id="res_name"></h1>
					<div>
						<img src="images/icon/icon1.png" width="13" height="13"> <span
							id="res_addr"></span>
						<p></p>
						<img src="images/icon/icon2.png" width="13" height="13"> <span
							style="font-family: 'KBO-Dia-Gothic_light';"> <span
							class="location">KT위즈파크</span>에서 걸어서 <span id="distance"></span>분
						</span>
					</div>
					<p></p>
					<img src="images/icon/icon3.png" width="13" height="13"> <span
						id="rating">&nbsp;</span>
					<p class="card-text mt-3" id="res_content"></p>
					<button type="submit" class="btn btn-primary mt-3 mb-3"
						id="review_btn">리뷰 보러가기</button>
					<button id="cancel" class="btn btn-primary mx-3">닫기</button>
					<button id="like_btn" class="btn btn-primary mt-3 me-3"
						style="float: right;">
						<img src="images/icon/dislike_icon.png" width=20 height=20>
					</button>
				</div>
			</div>
		</form>
	</div>
	<!--  전체 리스트 사이드바  -->
	<div class="sidebar" id="allinfo_sidebar">
		<div id="all_info"></div>
	</div>
	<!--  한식 리스트 사이드바  -->
	<div class="sidebar" id="KORinfo_sidebar">
		<div id="KOR_info"></div>
	</div>
	<!--  양식 리스트 사이드바  -->
	<div class="sidebar" id="USAinfo_sidebar">
		<div id="USA_info"></div>
	</div>
	<!--  중식 리스트 사이드바  -->
	<div class="sidebar" id="CHNinfo_sidebar">
		<div id="CHN_info"></div>
	</div>
	<!--  일식 리스트 사이드바  -->
	<div class="sidebar" id="JPNinfo_sidebar">
		<div id="JPN_info"></div>
	</div>
	<!--  카페 리스트 사이드바  -->
	<div class="sidebar" id="CAFEinfo_sidebar">
		<div id="CAFE_info"></div>
	</div>
	<!--  패스트푸드 리스트 사이드바  -->
	<div class="sidebar" id="FFinfo_sidebar">
		<div id="FF_info"></div>
	</div>
	<div class="mt-3 mb-2" id="containerDiv">
		<button class="btn btn-primary mb-2 category" id="find_all">맛집
			전체보기</button>
		<button class="btn btn-primary mb-2 category" id="find_KOR">🥘
			한식</button>
		<button class="btn btn-primary mb-2 category" id="find_USA">🍖
			양식</button>
		<button class="btn btn-primary mb-2 category" id="find_CHN">🥟
			중식</button>
		<button class="btn btn-primary mb-2 category" id="find_JPN">🍣
			일식</button>
		<button class="btn btn-primary mb-2 category" id="find_CAFE">☕️
			카페</button>
		<button class="btn btn-primary mb-2 category" id="find_FF">🍔
			패스트푸드</button>
		<div id="googleMap" style="width: 100%; height: 700px;"></div>
	</div>
	<script>
	// '찜하기' 버튼
    $(document).on('click', '#like_btn', function () {
        event.preventDefault();
        var res_id = $(this).data('res-id');

        $.ajax({
            url: 'like_res',
            method: 'GET',
            data: { res_id: res_id },
            success: function (data) {
                if (data === '로그인이 필요합니다.') {
                    Swal.fire({
                        text: data,
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonColor: '#3085d6',
                        cancelButtonColor: '#d33',
                        confirmButtonText: 'OK',
                        cancelButtonText: 'CANCLE',
                        button: {
                            text: '확인',
                            closeModal: true
                        }

                    }).then((result) => {
                        if (result.isConfirmed) {
                            window.location.href = '/app/loginForm';
                        }
                    });
                } else {
                    Swal.fire({
                        text: data,
                        icon: 'success',
                        confirmButtonColor: '#3085d6',
                        button: {
                            text: '확인',
                            closeModal: true
                        }
                    })
                }
            },
            error: function (error) {
                Swal.fire({
                    text: "이미 찜한 음식점입니다.",
                    icon: 'warning',
                    confirmButtonColor: '#3085d6',
                    button: {
                        text: '확인',
                        closeModal: true
                    }
                })
            }
        });
    });
	
	 // '닫기' 버튼
    $('#cancel').on('click', function () {
        event.preventDefault();
        $('#sidebar').hide();
        // 본문의 내용들 사라진 사이드바의 영역만큼 여백 제거
        $('.container').css("margin-left", 300);
    });

    var SidebarOpen = false;
    // '전체 맛집보기' 버튼
    $('#find_all').on('click', function () {
    	
    	 $('.sidebar:not(#allinfo_sidebar)').hide();
    	
        // 사이드바의 현재 상태 확인
        var SidebarOpen = $('#allinfo_sidebar').is(':visible');

        if (SidebarOpen) {
            // 사이드바가 열려있다면 닫기
            $('#allinfo_sidebar').hide();
            $('.container').css("margin-left", 300);
            SidebarOpen = false;
        } else {
        	$('#all_info').empty();
            $.ajax({
                // 사이드바가 닫혀있다면 열기
                url: 'find_all_res',
                method: 'GET',
                data: { team_code: 4 },
                success: function (data) {
                    // 성공적으로 데이터를 받아왔을 때의 처리

                    $.each(data, function (idx, ele) {

                        var cardId = 'card_' + idx;
                        var imagePath = 'https://kr.object.ncloudstorage.com/team2-bucket/restaurant_images/' + ele.res_image + '.png';
                        var res_name = ele.res_name;

                        var cardHtml = '<form id="' + cardId + '" action="r_reviewList" method="get">' +
                            '<input type="hidden" id="res_id" name="res_id" value="' + ele.res_id + '">' +
                            '<div class="card">' +
                            '<div"><img src="' + imagePath + '" class="card-img-top" alt="img" width="300px" height="300px"></div>' +
                            '<div class="card-body">' +
                            '<h1 class="card-title mt-3 mb-4" id="res_name">' + ele.res_name + '</h1>' +
                            '<div class="">' +
                            '<img src="images/icon/icon1.png" width="13" height="13"> <span id="res_addr">' + ele.res_addr + '</span>' +
                            '<p></p>' +
                            '<img src="images/icon/icon2.png" width="13" height="13"><span style="font-family: \'KBO-Dia-Gothic_light\';">&nbsp;<span class="location">KT위즈파크</span>에서 걸어서 <span id="distance" style="font-family: \'KBO-Dia-Gothic_bold\'; color: rgb(194, 48, 48);">' + ele.distance + '</span> 분</span>' +
                            '</div>' +
                            '<p></p>' +
                            '<img src="images/icon/icon3.png" width="13" height="13"><span>&nbsp;' +  ele.rating + '</span>' +
                            '<p class="card-text mt-3" id="res_content" style="font-family: \'KBO-Dia-Gothic_light\';">' + ele.res_content + '</p>' +
                            '<button type="submit" class="btn btn-primary mt-3 mb-3">리뷰 보러가기</button>' +
                            '<button class="btn btn-primary mt-3 mb-3 mx-3 find_res_btn" data-res-name="' + res_name + '">위치 보러가기</button>' +
                            '<button class="btn btn-primary mt-3 me-3" id="like_btn" data-res-id="' + ele.res_id + '" style="float:right;"><img src="images/icon/dislike_icon.png" width=20 height=20></button>' +
                            '</div>' +
                            '</div>' +
                            '</form>';

                        $('#all_info').append(cardHtml);
                    });

                },
                error: function (error) {
                    console.error('Error:', error);
                }
            });

            $('#allinfo_sidebar').show();
            $('.container').css("margin-left", 400);
        }
    });
    
    // '한식' 버튼
    $('#find_KOR').on('click', function () {
        findResByCategory('한식', 'KORinfo_sidebar', 'KOR_info');
    });
    // '양식' 버튼
    $('#find_USA').on('click', function () {
        findResByCategory('양식', 'USAinfo_sidebar', 'USA_info');
    });
    // '중식' 버튼
    $('#find_CHN').on('click', function () {
        findResByCategory('중식', 'CHNinfo_sidebar', 'CHN_info');
    });
    // '일식' 버튼
    $('#find_JPN').on('click', function () {
        findResByCategory('일식', 'JPNinfo_sidebar', 'JPN_info');
    });
    // '카페' 버튼
    $('#find_CAFE').on('click', function () {
        findResByCategory('카페', 'CAFEinfo_sidebar', 'CAFE_info');
    });
    // '패스트푸드' 버튼
    $('#find_FF').on('click', function () {
        findResByCategory('패스트푸드', 'FFinfo_sidebar', 'FF_info');
    });

    // 카테고리별 사이드바 open/close 함수
    function findResByCategory(category, sidebarId, infoId) {
        $('.sidebar:not(#' + sidebarId + ')').hide();

        // 사이드바의 현재 상태 확인
        var SidebarOpen = $('#' + sidebarId).is(':visible');

        if (SidebarOpen) {
            // 사이드바가 열려있다면 닫기
            $('#' + sidebarId).hide();
            $('.container').css("margin-left", 300);
        } else {
            // 사이드바가 닫혀있다면 열기
            $('#' + infoId).empty();
            $.ajax({
                url: 'find_res_by_category',
                method: 'GET',
                data: { category: category, team_code: 4 },
                success: function (data) {
                    // 성공적으로 데이터를 받아왔을 때의 처리
                    $.each(data, function (idx, ele) {
                        var cardId = 'card_' + idx;
                        var imagePath = 'https://kr.object.ncloudstorage.com/team2-bucket/restaurant_images/' + ele.res_image + '.png';
                        var res_name = ele.res_name;

                        var cardHtml = '<form id="' + cardId + '" action="r_reviewList" method="get">' +
                            '<input type="hidden" id="res_id" name="res_id" value="' + ele.res_id + '">' +
                            '<div class="card">' +
                            '<div"><img src="' + imagePath + '" class="card-img-top" alt="img" width="300px" height="300px"></div>' +
                            '<div class="card-body">' +
                            '<h1 class="card-title mt-3 mb-4" id="res_name">' + ele.res_name + '</h1>' +
                            '<div class="">' +
                            '<img src="images/icon/icon1.png" width="13" height="13"> <span id="res_addr">' + ele.res_addr + '</span>' +
                            '<p></p>' +
                            '<img src="images/icon/icon2.png" width="13" height="13"><span style="font-family: \'KBO-Dia-Gothic_light\';">&nbsp;<span class="location">KT위즈파크</span>에서 걸어서 <span id="distance">' + ele.distance + '</span> 분</span>' +
                            '</div>' +
                            '<p></p>' +
                            '<img src="images/icon/icon3.png" width="13" height="13"><span>&nbsp;' +  ele.rating + '</span>' +
                            '<p class="card-text mt-3" id="res_content"">' + ele.res_content + '</p>' +
                            '<button type="submit" class="btn btn-primary mt-3 mb-3">리뷰 보러가기</button>' +
                            '<button class="btn btn-primary mt-3 mb-3 mx-3 find_res_btn" data-res-name="' + res_name + '">위치 보러가기</button>' +
                            '<button class="btn btn-primary mt-3 me-3" id="like_btn" data-res-id="' + ele.res_id + '" style="float:right;"><img src="images/icon/dislike_icon.png" width=20 height=20></button>' +
                            '</div>' +
                            '</div>' +
                            '</form>';

                        $('#' + infoId).append(cardHtml);

                    });
                },
                error: function (error) {
                    console.error('Error:', error);
                }
            });

            $('#' + sidebarId).show();
            $('.container').css("margin-left", 400);
        }
    }


    var markerInfo = {};
    var map;
    $(document).on('click', '.find_res_btn', function (event) {
        event.preventDefault();
        var res_name = $(this).data('res-name');

        if (markerInfo[res_name]) {
            markerInfo[res_name].infowindow.open(map, markerInfo[res_name].marker);
        }

    });
    
	$('#containerDiv').addClass('container');
            function initMap() {
                const styledMapType = new google.maps.StyledMapType(
                    [
                        // 기존 마커 제거 
                        {
                            featureType: "poi",
                            elementType: "labels.icon",
                            stylers: [{ visibility: "off" }],
                        },
                    ],
                );

                // 수원 kt 위즈파크
                var mapOptions = { 
                        center: new google.maps.LatLng(37.299722, 127.009722 ),
                    zoom: 16.4 /* 음식점 & 숙소 마커 포함 이후 zoom 확대 예정 */
                };

                var map = new google.maps.Map(
                    document.getElementById("googleMap")
                    , mapOptions);

                map.mapTypes.set("styled_map", styledMapType);
                map.setMapTypeId("styled_map")

                var myIcon = new google.maps.MarkerImage("images/icon/restaurant_icon.png", null, null, null, new google.maps.Size(50, 57));


                for (var i = 0; i < locations.length; i++) {
                    // 마커에 대한 클로저를 생성합니다.
                    (function (i) {
                        var markerIcon = myIcon; // 기본 아이콘을 사용

                        if (locations[i].place === "수원 KT 위즈파크") {
                            // 경기장은 다른 아이콘을 사용
                            markerIcon = new google.maps.MarkerImage("images/icon/playground_icon.png", null, null, null, new google.maps.Size(50, 57));
                        }
                        if(locations[i].place === "스타벅스 수원종합운동장점" || locations[i].place === "미누알레" || locations[i].place === "슈아라크렘" ) {
                        	// 카페는 다른 아이콘을 사용
                        	markerIcon = new google.maps.MarkerImage("images/icon/cafe_icon.png", null, null, null, new google.maps.Size(50, 57));
                        }
                        var marker = new google.maps.Marker({
                            map: map,
                            position: new google.maps.LatLng(locations[i].lat, locations[i].lng),
                            icon: markerIcon
                        });
						
                        var infowindow = new google.maps.InfoWindow({
                            content: locations[i].place
                        });

                        // 마커와 InfoWindow를 객체에 저장
                        markerInfo[locations[i].place] = { marker: marker, infowindow: infowindow };
     

                     // 마커를 클릭 시, 이벤트 처리 
                        marker.addListener('click', function () {
                             if (locations[i].place === "수원 KT 위즈파크") {
                                // 경기장인 경우에는 라벨 텍스트를 표시
                                var infoWindow = new google.maps.InfoWindow({
                                    content: '수원 KT 위즈파크'
                                });

                                infoWindow.open(map, marker);
                            } else {
                            	$('.sidebar:not(#sidebar)').hide();
                                // 해당 맛집 정보 사이드바 표시 
                                $('#sidebar').show();
                                $('.container').css("margin-left", 400);

                                // 가게 이름 가져오기
                                var res_name = locations[i].place;

                                $.ajax({
                                    url: 'find_res',
                                    method: 'GET',
                                    data: { res_name: res_name },
                                    success: function (data) {
                                        // 성공적으로 데이터를 받아왔을 때의 처리
                                        console.log(data);
                                        console.log(data.res_content);
                                        var imagePath = 'https://kr.object.ncloudstorage.com/team2-bucket/restaurant_images/' + data.res_image + '.png';
                                        var imgTag = '<img src="' + imagePath + '" class="card-img-top" alt="img" width="300px" height="300px">'
                                        $('#res_image').html(imgTag);
                                        $('#res_name').text(data.res_name);
                                        $('#res_addr').text(data.res_addr);
                                        $('#distance').text(data.distance);
                                        $('#res_content').text(data.res_content);
                                        $('#res_id').val(data.res_id);
                                        $('#like_btn').data('res-id', data.res_id);

                                    },
                                    error: function (error) {
                                        console.error('Error:', error);
                                    }
                                });
                                $.ajax({
                                    url: 'find_res_rating',
                                    method: 'GET',
                                    data: { res_name: res_name },
                                    success: function (data) {
                                        // 성공적으로 데이터를 받아왔을 때의 처리
                                        $('#rating').text(data);

                                    },
                                    error: function (error) {
                                        // 오류 발생 시의 처리
                                        console.error('Error:', error);
                                    }
                                });
                            }
                        });
                    })(i); // 즉시 실행 함수로 현재의 i 값을 전달
                }
            }

            const locations = [
                {place: "수원 KT 위즈파크", lat: 37.299722, lng: 127.009722 },
                { place: "그집해장국", lat: 37.2966454, lng: 127.0123604 },
                { place: "수지본동태탕", lat: 37.2991413, lng: 127.0067546 },
                { place: "임가네 칡냉면", lat: 37.299835, lng:  127.013542},
                { place: "김경자소문난대구왕뽈찜", lat: 37.3033285, lng: 127.0052111},
                { place: "할머니손순대", lat: 37.3017317, lng: 127.010065},
                { place: "보영만두", lat:  37.299360, lng: 127.010470},
                { place: "이비가짬뽕 수원KT위즈파크점", lat: 37.300689, lng: 127.011064},
                { place: "서진불닭발", lat: 37.300771, lng: 127.007103},
                { place: "닭갈비잔치", lat: 37.299467, lng: 127.012333},
                { place: "마왕소곱창", lat: 37.3012219, lng: 127.0080872},
                { place: "스타벅스 수원종합운동장점", lat: 37.301346, lng: 127.008886 },
                { place: "잔칫집", lat: 37.299596, lng: 127.005832 },
                { place: "미누알레", lat: 37.299685, lng: 127.006599 },
                { place: "장안먹거리", lat: 37.301884, lng: 127.010365},
                { place: "뉴욕핫도그앤커피", lat: 37.300119, lng: 127.009226},
                { place: "북경", lat: 37.300684, lng: 127.008031 },
                { place: "울금향 마라탕", lat: 37.301092, lng: 127.007983},
                { place: "홍콩반점0410 수원장안구청점", lat: 37.301933, lng: 127.009256 },
                { place: "남바완돈카츠 수원장안점", lat: 37.294668, lng: 127.008943 },
                { place: "미소야 수원장안구청점", lat: 37.301704, lng: 127.008236 },
                { place: "초밥집", lat: 37.302080, lng: 127.010497 },
                { place: "신기소 홈플러스북수원점", lat: 37.302535, lng: 127.008837 },
                { place: "UNIT101", lat: 37.297522, lng: 127.017041 },
                { place: "어반포크", lat: 37.303082, lng: 127.008166 },
                { place: "키친에프", lat: 37.303366, lng: 127.007482 },
                { place: "심야스테이크 송죽점", lat: 37.302747, lng: 127.005277 },
                { place: "피자헛 수원송죽점", lat: 37.299885, lng: 127.007652 },
                { place: "맘스터치 수원조원점", lat: 37.302194, lng: 127.009464 },
                { place: "BBQ치킨 수원조원점", lat: 37.301550, lng: 127.009657 },
                { place: "슈아라크렘", lat: 37.301107, lng: 127.008302 },
            ];

            window.initMap = initMap;
	
        </script>
        <script src="https://maps.googleapis.com/maps/api/js?key=${googleMapsApiKey}&callback=initMap"></script>
</body>

</html>