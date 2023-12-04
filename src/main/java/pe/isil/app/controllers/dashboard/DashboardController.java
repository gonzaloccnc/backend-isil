package pe.isil.app.controllers.dashboard;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import pe.isil.app.domain.models.DashboardEvaluations;
import pe.isil.app.domain.models.DashboardTodayClasses;
import pe.isil.app.domain.repos.DashboardEvaluationsRepo;
import pe.isil.app.domain.repos.DashboardTodayClassesRepo;

import java.util.List;

@RestController
@RequestMapping("/dashboard")
@RequiredArgsConstructor
public class DashboardController {

  private final DashboardEvaluationsRepo dashboardEvaluationsRepo;
  private final DashboardTodayClassesRepo dashboardTodayClassesRepo;

  @GetMapping("/evaluations/{idStudent}")
  public List<DashboardEvaluations> getEvaluations(@PathVariable String idStudent) {
    return dashboardEvaluationsRepo.findAllByIdStudent(idStudent);
  }

  @GetMapping("/today/classes/{idStudent}")
  public List<DashboardTodayClasses> getTodayClasses(@PathVariable String idStudent) {
    return dashboardTodayClassesRepo.findAllByIdStudent(idStudent);
  }

}
