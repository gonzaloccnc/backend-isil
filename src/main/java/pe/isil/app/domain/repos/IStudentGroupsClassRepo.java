package pe.isil.app.domain.repos;

import pe.isil.app.domain.models.StudentGroupsClasses;

import java.util.List;

public interface IStudentGroupsClassRepo extends IReadOnlyRepo<StudentGroupsClasses, String> {
  List<StudentGroupsClasses> findAllByIdClassroom(String idClassroom);
}
