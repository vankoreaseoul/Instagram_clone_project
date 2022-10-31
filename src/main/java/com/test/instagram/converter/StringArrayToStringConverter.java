package com.test.instagram.converter;

import org.apache.tomcat.util.buf.StringUtils;

import java.util.Arrays;
import java.util.List;
import javax.persistence.AttributeConverter;

import static java.util.Collections.emptyList;

public class StringArrayToStringConverter implements AttributeConverter<List<String>, String> {

    private static final String SPLIT_CHAR = ",";

    @Override
    public String convertToDatabaseColumn(List<String> stringList) {
        return stringList != null ? String.join(SPLIT_CHAR, stringList) : "";
    }

    @Override
    public List<String> convertToEntityAttribute(String string) {
        return string != null ? Arrays.asList(string.split(SPLIT_CHAR)) : emptyList();
    }
}
