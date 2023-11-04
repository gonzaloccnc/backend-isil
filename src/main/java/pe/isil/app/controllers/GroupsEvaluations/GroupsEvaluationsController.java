package pe.isil.app.controllers.GroupsEvaluations;


import lombok.RequiredArgsConstructor;

import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import pe.isil.app.domain.dtos.GroupsDto;
import pe.isil.app.domain.dtos.ListGroupDto;
import pe.isil.app.domain.models.ClassGroupsStudents;
import pe.isil.app.domain.models.GroupsClass;

import pe.isil.app.domain.models.KeyClass;
import pe.isil.app.domain.repos.IClassGroupsStudentsRepo;
import pe.isil.app.domain.repos.IGroupsEvaluationsRepo;

import java.time.LocalDateTime;

import java.util.ArrayList;
import java.util.UUID;

@RestController
@RequestMapping("/admin/groups")
@RequiredArgsConstructor
public class GroupsEvaluationsController {

    private final IGroupsEvaluationsRepo groupService;
    private final IClassGroupsStudentsRepo groupsStudentsRepo;
    @PostMapping("/create")
    @Transactional
    public GroupsDto createGroups(@RequestBody ListGroupDto groupsEvaluations) {



        //   groupsEvaluations.setIdGroup(UUID.randomUUID().toString());
        var group = groupService.save(GroupsClass.builder().groupName(groupsEvaluations.getGroupName()).build());
        var KeyComp = new ArrayList<ClassGroupsStudents>();
        groupsEvaluations.getStudents().forEach(x -> {
            var key = KeyClass.builder()
                    .idStudent(x.getIdStudents())
                    .idClassroom(x.getIdClassroom())
                    .build();

            var r = ClassGroupsStudents.builder().keyClass(key).idGroup(group.getIdGroup()).build();
            KeyComp.add(r);
        });


        groupsStudentsRepo.saveAll(KeyComp);


        return null;
    }
    @PutMapping("/update/{idClassRoom}")
    public GroupsClass updateGroups(@RequestBody ListGroupDto groupsEvaluations, @PathVariable("idClassRoom")String idClassRoom){
        //GroupsClass groupsFromDB = groupService.findById(idGroup).orElse(null);

        //   groupsEvaluations.setIdGroup(UUID.randomUUID().toString());
        var group = groupService.save(GroupsClass.builder().groupName(groupsEvaluations.getGroupName()).build());
        var KeyComp = new ArrayList<ClassGroupsStudents>();
        groupsEvaluations.getStudents().forEach(x -> {
            var key = KeyClass.builder()
                    .idStudent(x.getIdStudents())
                    .idClassroom(x.getIdClassroom())
                    .build();

            var r = ClassGroupsStudents.builder().keyClass(key).idGroup(group.getIdGroup()).build();
            KeyComp.add(r);

        });


        groupsStudentsRepo.saveAll(KeyComp);

        return null;

    }




}
