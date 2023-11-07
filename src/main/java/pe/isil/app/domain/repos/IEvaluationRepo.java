package pe.isil.app.domain.repos;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.isil.app.domain.models.Evaluation;

import java.util.List;

public interface IEvaluationRepo extends JpaRepository<Evaluation, Integer> {
  List<Evaluation> findAllByIdClassroom(String idClassroom);
}
