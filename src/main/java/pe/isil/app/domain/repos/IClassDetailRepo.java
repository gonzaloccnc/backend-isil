package pe.isil.app.domain.repos;

import pe.isil.app.domain.models.Classroom;
import pe.isil.app.domain.models.DetailClass;

import java.util.List;

public interface IClassDetailRepo extends IReadOnlyRepo <DetailClass, String>{
    List<DetailClass>findAllByIdTeacher(String idTeacher);
    List<DetailClass>findAllByIdStudent(String idStudent);

}
