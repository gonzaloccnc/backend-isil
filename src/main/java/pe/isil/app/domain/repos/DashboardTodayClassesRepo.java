package pe.isil.app.domain.repos;

import pe.isil.app.domain.models.DashboardTodayClasses;

import java.util.List;

public interface DashboardTodayClassesRepo extends IReadOnlyRepo<DashboardTodayClasses, String> {
  List<DashboardTodayClasses> findAllByIdStudent(String idStudent);
}
