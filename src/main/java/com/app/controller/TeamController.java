package com.app.controller;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.app.dto.MemberDTO;
import com.app.dto.PlayerDTO;
import com.app.dto.ScheduleDTO;
import com.app.dto.TeamDTO;
import com.app.dto.likePlayerDTO;
import com.app.service.MemberService;
import com.app.service.PlayerService;
import com.app.service.ScrapingService;
import com.app.service.TeamService;

@Controller
public class TeamController {

	@Autowired
	private MemberService memberService;
	@Autowired
	private ScrapingService scrapService;
	@Autowired
	private PlayerService playerService;
	@Autowired
	private TeamService teamService;

	@RequestMapping("/schedule")
	public String schedule(Model model, HttpSession session) {
		MemberDTO dto = (MemberDTO) session.getAttribute("login");
		String userid = dto.getUserid();

		MemberDTO user = memberService.mypage(userid);
		session.setAttribute("login", user);

		List<ScheduleDTO> allScheduleList = playerService.findSchedule(); // 일정 가져오기
		List<TeamDTO> teamDataList = playerService.findRank(); // 순위 및 정보 가져오기

		int myTeam = dto.getTeam_code();
		String selectedTeam = teamService.team_name(myTeam);
		
		model.addAttribute("ScoreBoard", scrapService.scrapeScore());

		model.addAttribute("myTeam", selectedTeam);
		// 응원팀에 해당하는 일정만 필터링하기
		List<ScheduleDTO> filterScheduleList = new ArrayList<ScheduleDTO>();
		for (ScheduleDTO schedule : allScheduleList) {
			if (schedule.getTeam1().equals(selectedTeam) || schedule.getTeam2().equals(selectedTeam)) {
				filterScheduleList.add(schedule);
			}
		}
		model.addAttribute("filterScheduleList", filterScheduleList);

		return "/team/schedule";
	}

	@RequestMapping("/highlight")
	public String highlight(Model model, HttpSession session) {
		MemberDTO dto = (MemberDTO) session.getAttribute("login");
		model.addAttribute("user", dto);
		model.addAttribute("highlight", playerService.findHighlight());
		int myTeam = dto.getTeam_code();
		String selectedTeam = teamService.team_name(myTeam);

		model.addAttribute("myTeam", selectedTeam);

		return "/team/highlight";
	}

	@RequestMapping("/rank")
	public String rank(Model model, HttpSession session) {
		MemberDTO dto = (MemberDTO) session.getAttribute("login");

		int myTeam = dto.getTeam_code();
		String selectedTeam = teamService.team_name(myTeam);

		model.addAttribute("myTeam", selectedTeam);

		List<TeamDTO> teamDataList = playerService.findRank();
		TeamDTO filterTeamData = new TeamDTO();
		for (TeamDTO team : teamDataList) {
			if (team.getTitle().equals(selectedTeam)) {
				filterTeamData = team;
			}
		}

		model.addAttribute("filterTeamData", filterTeamData);
		return "/team/rank";
	}

	@RequestMapping("/players")
	public String players(HttpSession session, Model model,
			@RequestParam(value = "position", required = false, defaultValue = "null") String pos) {
		MemberDTO dto = (MemberDTO) session.getAttribute("login");
		int myTeam = dto.getTeam_code();
		String selectedTeam = teamService.team_name(myTeam);
		model.addAttribute("myTeam", selectedTeam);
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("team", selectedTeam);
		map.put("pos", pos);
		List<PlayerDTO> list = playerService.find_Allplayer(map);
		model.addAttribute("list", list);
		return "/team/players";
	}

	@GetMapping("/playerInfo")
	public String playerInfo(String player, String team, Model model) {

		HashMap<String, String> map = new HashMap<String, String>();
		map.put("team", team);
		map.put("player", player);
		PlayerDTO dto = playerService.find_player(map);
		model.addAttribute("dto", dto);

		return "/team/playerInfo";
	}

	@RequestMapping("/record")
	public String record(Model model, HttpSession session) {
		MemberDTO dto = (MemberDTO) session.getAttribute("login");

		List<ScheduleDTO> allScheduleList = playerService.findSchedule(); // 일정 가져오기

		String selectedTeam = teamService.team_name(dto.getTeam_code());
		model.addAttribute("myTeam", selectedTeam);

		// 응원팀에 해당하는 일정만 필터링하기
		List<ScheduleDTO> filterScheduleList = new ArrayList<ScheduleDTO>();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM.dd(E)", Locale.ENGLISH);

		LocalDate today = LocalDate.now();

		for (ScheduleDTO schedule : allScheduleList) {
			String dateString = schedule.getDay();
			int month = Integer.parseInt(dateString.substring(0, 2));
			int day = Integer.parseInt(dateString.substring(3, 5));

			LocalDate scheduleDate = LocalDate.of(LocalDate.now().getYear(), month, day);

			if ((schedule.getTeam1().equals(selectedTeam) || schedule.getTeam2().equals(selectedTeam))
					&& scheduleDate.isBefore(today)) {
				filterScheduleList.add(schedule);
			}
		}
		model.addAttribute("filterScheduleList", filterScheduleList);

		return "/team/record";
	}

	@PostMapping("/recordInfo")
	@ResponseBody
	public String recordInfo(@RequestParam("requestData") String day) {
		// 1. DB에 저장된 데이터인지 확인
		// 2. DB에 없으면 경기결과 scrap 해온 후 DB에 저장

		String record = playerService.findRecord(day);

		if (record == null) {
			String recordHtml = scrapService.scrapeRecord(day);
			HashMap<String, String> map = new HashMap<String, String>();
			map.put("day", day);
			map.put("html", recordHtml);
			int n = playerService.saveRecord(map);
			return recordHtml;
		} else {
			return record;
		}
	}
	
	@GetMapping("/likePlayer")
	@ResponseBody
	public String likePlayer(likePlayerDTO dto, HttpSession session) {
		MemberDTO mDTO = (MemberDTO) session.getAttribute("login");
		dto.setUserid(mDTO.getUserid());	
		int n = playerService.like_player(dto);
		
		if(n>0) {
			n = playerService.plus_likeCnt(dto);
			return dto.getPlayer()+"의 팬이 되었습니다.";
		} else {
			return "팬 등록을 실패하였습니다.";
		}
	}
	
	@RequestMapping("/myPlayer")
	public String myPlayer(HttpSession session, Model model) {
		
		MemberDTO mDTO = (MemberDTO) session.getAttribute("login");
		List<PlayerDTO> list = playerService.find_myPlayer(mDTO.getUserid());
		model.addAttribute("list", list);
		return "/team/myPlayer";
	}
	
	@GetMapping("/deletePlayer")
	@ResponseBody
	public String deletePlayer(likePlayerDTO dto, HttpSession session) {
		MemberDTO mDTO = (MemberDTO) session.getAttribute("login");
		dto.setUserid(mDTO.getUserid());	
		int n = playerService.deletePlayer(dto);
		if(n>0) {
			n = playerService.minus_likeCnt(dto);
			return dto.getPlayer()+"의 팬이 해제되었습니다.";
		} else {
			return "팬 해제를 실패하였습니다.";
		}
	}
}
