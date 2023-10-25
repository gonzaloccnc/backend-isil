package pe.isil.app.domain.repos;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.isil.app.domain.models.ClassroomView;

import java.util.Optional;

public interface IClassroomViewRepo extends IReadOnlyRepo<ClassroomView, String> {
  Optional<ClassroomView> findByIdClassroom(String id);
  Page<ClassroomView> findAllByCourseContains(Pageable pageable, String name);
}
