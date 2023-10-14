package pe.isil.app.domain.repos;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.isil.app.domain.models.Content;

import java.util.List;

public interface IContentRepo extends JpaRepository<Content, Integer> {
  List<Content> findByIdCourse(String idCourse);
}
