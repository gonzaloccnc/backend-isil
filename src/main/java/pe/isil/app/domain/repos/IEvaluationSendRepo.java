package pe.isil.app.domain.repos;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.isil.app.domain.models.EvaluationSend;

public interface IEvaluationSendRepo extends JpaRepository<EvaluationSend, Integer> {
}
