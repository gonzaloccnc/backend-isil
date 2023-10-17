package pe.isil.app.domain.repos;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.isil.app.domain.models.Complementaries;

import java.util.List;

public interface IComplementariesRepo extends JpaRepository<Complementaries, String> {
  List<Complementaries> findAllByIdClassroom(String idClass);
}
