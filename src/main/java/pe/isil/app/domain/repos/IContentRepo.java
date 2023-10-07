package pe.isil.app.domain.repos;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.isil.app.domain.models.Content;

public interface IContentRepo extends JpaRepository<Content, Integer> {
}
