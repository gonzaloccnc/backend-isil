package pe.isil.app.domain.repos;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.isil.app.domain.models.Classroom;

public interface IClassroomRepo extends JpaRepository<Classroom, String> {
}
