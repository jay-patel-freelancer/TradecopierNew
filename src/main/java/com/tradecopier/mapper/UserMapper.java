package com.tradecopier.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;
import org.springframework.stereotype.Component;

import com.tradecopier.domains.User;
import com.tradecopier.dto.UserDTO;
@Component
@Mapper(componentModel = "spring")
public interface UserMapper extends Entity<UserDTO,User> {

	@Mappings({ @Mapping(target = "employeeId", source = "entity.id"),
			@Mapping(target = "employeeName", source = "entity.name") })
	UserDTO toDto(User user);

	@Mappings({ @Mapping(target = "employeeId", source = "entity.id"),
			@Mapping(target = "employeeName", source = "entity.name") })
	User toEntity(UserDTO userDTO);
}
