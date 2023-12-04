package pe.isil.app.domain.repos;

import pe.isil.app.domain.models.DashboardEvaluations;

import java.util.List;

public interface DashboardEvaluationsRepo extends IReadOnlyRepo<DashboardEvaluations, Integer> {
  List<DashboardEvaluations> findAllByIdStudent(String idStudent);
}
