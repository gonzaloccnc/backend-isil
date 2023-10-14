package pe.isil.app.domain.repos;

import pe.isil.app.domain.models.ClassroomView;

import java.util.Optional;

public interface IClassroomViewRepo extends IReadOnlyRepo<ClassroomView, String> {
  Optional<ClassroomView> findByIdClassroom(String id);
}
