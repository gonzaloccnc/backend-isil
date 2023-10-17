package pe.isil.app.domain.repos;

import org.springframework.data.jpa.repository.JpaRepository;

import pe.isil.app.domain.models.Course;
import pe.isil.app.domain.models.DetailClass;

import java.util.List;


public interface ICourseRepo extends JpaRepository<Course, String> {


}
