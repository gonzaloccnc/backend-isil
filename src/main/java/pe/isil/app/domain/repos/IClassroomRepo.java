package pe.isil.app.domain.repos;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.isil.app.domain.dtos.ClassroomDto;
import pe.isil.app.domain.models.Classroom;

import java.util.List;
import java.util.Optional;

public interface IClassroomRepo extends JpaRepository<Classroom, String> {


}
