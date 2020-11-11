package com.tradecopier.mapper;

public interface Entity<D, T> {
	D toDto(T t);
	T toEntity(D d);
}
