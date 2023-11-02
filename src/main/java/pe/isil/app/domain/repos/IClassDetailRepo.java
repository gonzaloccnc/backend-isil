package pe.isil.app.domain.repos;

import pe.isil.app.domain.models.DetailClass;

import java.util.List;
import java.util.Set;

public interface IClassDetailRepo extends IReadOnlyRepo <DetailClass, String>{
    Set<DetailClass> findAllByIdTeacher(String idTeacher);
    Set<DetailClass>findAllByIdStudent(String idStudent);

}
