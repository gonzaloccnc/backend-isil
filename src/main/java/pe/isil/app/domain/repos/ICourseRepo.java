package pe.isil.app.domain.repos;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import pe.isil.app.domain.models.Course;
import pe.isil.app.domain.models.DetailClass;

import java.util.List;
import java.util.Optional;


public interface ICourseRepo extends JpaRepository<Course, String> {

  Page<Course> findCourseByCourseNameContains(Pageable pageable, String name);
}
