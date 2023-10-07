package pe.isil.app.domain.repos;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import pe.isil.app.domain.models.Course;

import java.util.Optional;

@Repository
public interface ICourseRepo extends JpaRepository<Course, String> {


}
