// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_collections.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMenuItemCollectionCollection on Isar {
  IsarCollection<MenuItemCollection> get menuItemCollections =>
      this.collection();
}

const MenuItemCollectionSchema = CollectionSchema(
  name: r'MenuItemCollection',
  id: -9162736578015733379,
  properties: {
    r'allergens': PropertySchema(
      id: 0,
      name: r'allergens',
      type: IsarType.stringList,
    ),
    r'calorificValue': PropertySchema(
      id: 1,
      name: r'calorificValue',
      type: IsarType.long,
    ),
    r'dietaryTags': PropertySchema(
      id: 2,
      name: r'dietaryTags',
      type: IsarType.stringList,
    ),
    r'imageUrl': PropertySchema(
      id: 3,
      name: r'imageUrl',
      type: IsarType.string,
    ),
    r'ingredients': PropertySchema(
      id: 4,
      name: r'ingredients',
      type: IsarType.string,
    ),
    r'isAvailable': PropertySchema(
      id: 5,
      name: r'isAvailable',
      type: IsarType.bool,
    ),
    r'isFrequentlySold': PropertySchema(
      id: 6,
      name: r'isFrequentlySold',
      type: IsarType.bool,
    ),
    r'itemGroup': PropertySchema(
      id: 7,
      name: r'itemGroup',
      type: IsarType.string,
    ),
    r'kitchenCategory': PropertySchema(
      id: 8,
      name: r'kitchenCategory',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 9,
      name: r'name',
      type: IsarType.string,
    ),
    r'portion': PropertySchema(
      id: 10,
      name: r'portion',
      type: IsarType.string,
    ),
    r'price': PropertySchema(
      id: 11,
      name: r'price',
      type: IsarType.double,
    ),
    r'remoteId': PropertySchema(
      id: 12,
      name: r'remoteId',
      type: IsarType.long,
    ),
    r'salesCategory': PropertySchema(
      id: 13,
      name: r'salesCategory',
      type: IsarType.string,
    ),
    r'serviceTime': PropertySchema(
      id: 14,
      name: r'serviceTime',
      type: IsarType.long,
    ),
    r'shortCode': PropertySchema(
      id: 15,
      name: r'shortCode',
      type: IsarType.string,
    ),
    r'shortDescription': PropertySchema(
      id: 16,
      name: r'shortDescription',
      type: IsarType.string,
    ),
    r'taxTemplate': PropertySchema(
      id: 17,
      name: r'taxTemplate',
      type: IsarType.string,
    ),
    r'vegType': PropertySchema(
      id: 18,
      name: r'vegType',
      type: IsarType.string,
    )
  },
  estimateSize: _menuItemCollectionEstimateSize,
  serialize: _menuItemCollectionSerialize,
  deserialize: _menuItemCollectionDeserialize,
  deserializeProp: _menuItemCollectionDeserializeProp,
  idName: r'id',
  indexes: {
    r'remoteId': IndexSchema(
      id: 6301175856541681032,
      name: r'remoteId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'remoteId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _menuItemCollectionGetId,
  getLinks: _menuItemCollectionGetLinks,
  attach: _menuItemCollectionAttach,
  version: '3.1.0+1',
);

int _menuItemCollectionEstimateSize(
  MenuItemCollection object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final list = object.allergens;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final list = object.dietaryTags;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final value = object.imageUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.ingredients;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.itemGroup.length * 3;
  {
    final value = object.kitchenCategory;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  {
    final value = object.portion;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.salesCategory;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.shortCode.length * 3;
  {
    final value = object.shortDescription;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.taxTemplate.length * 3;
  bytesCount += 3 + object.vegType.length * 3;
  return bytesCount;
}

void _menuItemCollectionSerialize(
  MenuItemCollection object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeStringList(offsets[0], object.allergens);
  writer.writeLong(offsets[1], object.calorificValue);
  writer.writeStringList(offsets[2], object.dietaryTags);
  writer.writeString(offsets[3], object.imageUrl);
  writer.writeString(offsets[4], object.ingredients);
  writer.writeBool(offsets[5], object.isAvailable);
  writer.writeBool(offsets[6], object.isFrequentlySold);
  writer.writeString(offsets[7], object.itemGroup);
  writer.writeString(offsets[8], object.kitchenCategory);
  writer.writeString(offsets[9], object.name);
  writer.writeString(offsets[10], object.portion);
  writer.writeDouble(offsets[11], object.price);
  writer.writeLong(offsets[12], object.remoteId);
  writer.writeString(offsets[13], object.salesCategory);
  writer.writeLong(offsets[14], object.serviceTime);
  writer.writeString(offsets[15], object.shortCode);
  writer.writeString(offsets[16], object.shortDescription);
  writer.writeString(offsets[17], object.taxTemplate);
  writer.writeString(offsets[18], object.vegType);
}

MenuItemCollection _menuItemCollectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MenuItemCollection();
  object.allergens = reader.readStringList(offsets[0]);
  object.calorificValue = reader.readLongOrNull(offsets[1]);
  object.dietaryTags = reader.readStringList(offsets[2]);
  object.id = id;
  object.imageUrl = reader.readStringOrNull(offsets[3]);
  object.ingredients = reader.readStringOrNull(offsets[4]);
  object.isAvailable = reader.readBool(offsets[5]);
  object.isFrequentlySold = reader.readBool(offsets[6]);
  object.itemGroup = reader.readString(offsets[7]);
  object.kitchenCategory = reader.readStringOrNull(offsets[8]);
  object.name = reader.readString(offsets[9]);
  object.portion = reader.readStringOrNull(offsets[10]);
  object.price = reader.readDouble(offsets[11]);
  object.remoteId = reader.readLong(offsets[12]);
  object.salesCategory = reader.readStringOrNull(offsets[13]);
  object.serviceTime = reader.readLongOrNull(offsets[14]);
  object.shortCode = reader.readString(offsets[15]);
  object.shortDescription = reader.readStringOrNull(offsets[16]);
  object.taxTemplate = reader.readString(offsets[17]);
  object.vegType = reader.readString(offsets[18]);
  return object;
}

P _menuItemCollectionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringList(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readStringList(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readDouble(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (reader.readLongOrNull(offset)) as P;
    case 15:
      return (reader.readString(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    case 17:
      return (reader.readString(offset)) as P;
    case 18:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _menuItemCollectionGetId(MenuItemCollection object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _menuItemCollectionGetLinks(
    MenuItemCollection object) {
  return [];
}

void _menuItemCollectionAttach(
    IsarCollection<dynamic> col, Id id, MenuItemCollection object) {
  object.id = id;
}

extension MenuItemCollectionByIndex on IsarCollection<MenuItemCollection> {
  Future<MenuItemCollection?> getByRemoteId(int remoteId) {
    return getByIndex(r'remoteId', [remoteId]);
  }

  MenuItemCollection? getByRemoteIdSync(int remoteId) {
    return getByIndexSync(r'remoteId', [remoteId]);
  }

  Future<bool> deleteByRemoteId(int remoteId) {
    return deleteByIndex(r'remoteId', [remoteId]);
  }

  bool deleteByRemoteIdSync(int remoteId) {
    return deleteByIndexSync(r'remoteId', [remoteId]);
  }

  Future<List<MenuItemCollection?>> getAllByRemoteId(List<int> remoteIdValues) {
    final values = remoteIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'remoteId', values);
  }

  List<MenuItemCollection?> getAllByRemoteIdSync(List<int> remoteIdValues) {
    final values = remoteIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'remoteId', values);
  }

  Future<int> deleteAllByRemoteId(List<int> remoteIdValues) {
    final values = remoteIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'remoteId', values);
  }

  int deleteAllByRemoteIdSync(List<int> remoteIdValues) {
    final values = remoteIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'remoteId', values);
  }

  Future<Id> putByRemoteId(MenuItemCollection object) {
    return putByIndex(r'remoteId', object);
  }

  Id putByRemoteIdSync(MenuItemCollection object, {bool saveLinks = true}) {
    return putByIndexSync(r'remoteId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByRemoteId(List<MenuItemCollection> objects) {
    return putAllByIndex(r'remoteId', objects);
  }

  List<Id> putAllByRemoteIdSync(List<MenuItemCollection> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'remoteId', objects, saveLinks: saveLinks);
  }
}

extension MenuItemCollectionQueryWhereSort
    on QueryBuilder<MenuItemCollection, MenuItemCollection, QWhere> {
  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterWhere>
      anyRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'remoteId'),
      );
    });
  }
}

extension MenuItemCollectionQueryWhere
    on QueryBuilder<MenuItemCollection, MenuItemCollection, QWhereClause> {
  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterWhereClause>
      remoteIdEqualTo(int remoteId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'remoteId',
        value: [remoteId],
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterWhereClause>
      remoteIdNotEqualTo(int remoteId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'remoteId',
              lower: [],
              upper: [remoteId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'remoteId',
              lower: [remoteId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'remoteId',
              lower: [remoteId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'remoteId',
              lower: [],
              upper: [remoteId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterWhereClause>
      remoteIdGreaterThan(
    int remoteId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'remoteId',
        lower: [remoteId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterWhereClause>
      remoteIdLessThan(
    int remoteId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'remoteId',
        lower: [],
        upper: [remoteId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterWhereClause>
      remoteIdBetween(
    int lowerRemoteId,
    int upperRemoteId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'remoteId',
        lower: [lowerRemoteId],
        includeLower: includeLower,
        upper: [upperRemoteId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MenuItemCollectionQueryFilter
    on QueryBuilder<MenuItemCollection, MenuItemCollection, QFilterCondition> {
  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      allergensIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'allergens',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      allergensIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'allergens',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      allergensElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'allergens',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      allergensElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'allergens',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      allergensElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'allergens',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      allergensElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'allergens',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      allergensElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'allergens',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      allergensElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'allergens',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      allergensElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'allergens',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      allergensElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'allergens',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      allergensElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'allergens',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      allergensElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'allergens',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      allergensLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'allergens',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      allergensIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'allergens',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      allergensIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'allergens',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      allergensLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'allergens',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      allergensLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'allergens',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      allergensLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'allergens',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      calorificValueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'calorificValue',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      calorificValueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'calorificValue',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      calorificValueEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'calorificValue',
        value: value,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      calorificValueGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'calorificValue',
        value: value,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      calorificValueLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'calorificValue',
        value: value,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      calorificValueBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'calorificValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      dietaryTagsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dietaryTags',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      dietaryTagsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dietaryTags',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      dietaryTagsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dietaryTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      dietaryTagsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dietaryTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      dietaryTagsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dietaryTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      dietaryTagsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dietaryTags',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      dietaryTagsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dietaryTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      dietaryTagsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dietaryTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      dietaryTagsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dietaryTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      dietaryTagsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dietaryTags',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      dietaryTagsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dietaryTags',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      dietaryTagsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dietaryTags',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      dietaryTagsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dietaryTags',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      dietaryTagsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dietaryTags',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      dietaryTagsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dietaryTags',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      dietaryTagsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dietaryTags',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      dietaryTagsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dietaryTags',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      dietaryTagsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dietaryTags',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      imageUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'imageUrl',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      imageUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'imageUrl',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      imageUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      imageUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      imageUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      imageUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imageUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      imageUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      imageUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      imageUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      imageUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imageUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      imageUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      imageUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      ingredientsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'ingredients',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      ingredientsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'ingredients',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      ingredientsEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ingredients',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      ingredientsGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ingredients',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      ingredientsLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ingredients',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      ingredientsBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ingredients',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      ingredientsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ingredients',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      ingredientsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ingredients',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      ingredientsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ingredients',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      ingredientsMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ingredients',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      ingredientsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ingredients',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      ingredientsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ingredients',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      isAvailableEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isAvailable',
        value: value,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      isFrequentlySoldEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isFrequentlySold',
        value: value,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      itemGroupEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemGroup',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      itemGroupGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'itemGroup',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      itemGroupLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'itemGroup',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      itemGroupBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'itemGroup',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      itemGroupStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'itemGroup',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      itemGroupEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'itemGroup',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      itemGroupContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'itemGroup',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      itemGroupMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'itemGroup',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      itemGroupIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemGroup',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      itemGroupIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'itemGroup',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      kitchenCategoryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'kitchenCategory',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      kitchenCategoryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'kitchenCategory',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      kitchenCategoryEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'kitchenCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      kitchenCategoryGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'kitchenCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      kitchenCategoryLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'kitchenCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      kitchenCategoryBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'kitchenCategory',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      kitchenCategoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'kitchenCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      kitchenCategoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'kitchenCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      kitchenCategoryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'kitchenCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      kitchenCategoryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'kitchenCategory',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      kitchenCategoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'kitchenCategory',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      kitchenCategoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'kitchenCategory',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      portionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'portion',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      portionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'portion',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      portionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'portion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      portionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'portion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      portionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'portion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      portionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'portion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      portionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'portion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      portionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'portion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      portionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'portion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      portionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'portion',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      portionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'portion',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      portionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'portion',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      priceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'price',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      priceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'price',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      priceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'price',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      priceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'price',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      remoteIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remoteId',
        value: value,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      remoteIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'remoteId',
        value: value,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      remoteIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'remoteId',
        value: value,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      remoteIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'remoteId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      salesCategoryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'salesCategory',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      salesCategoryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'salesCategory',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      salesCategoryEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'salesCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      salesCategoryGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'salesCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      salesCategoryLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'salesCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      salesCategoryBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'salesCategory',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      salesCategoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'salesCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      salesCategoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'salesCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      salesCategoryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'salesCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      salesCategoryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'salesCategory',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      salesCategoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'salesCategory',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      salesCategoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'salesCategory',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      serviceTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'serviceTime',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      serviceTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'serviceTime',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      serviceTimeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serviceTime',
        value: value,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      serviceTimeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'serviceTime',
        value: value,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      serviceTimeLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'serviceTime',
        value: value,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      serviceTimeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'serviceTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      shortCodeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shortCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      shortCodeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'shortCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      shortCodeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'shortCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      shortCodeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'shortCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      shortCodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'shortCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      shortCodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'shortCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      shortCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'shortCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      shortCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'shortCode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      shortCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shortCode',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      shortCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'shortCode',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      shortDescriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'shortDescription',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      shortDescriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'shortDescription',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      shortDescriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shortDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      shortDescriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'shortDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      shortDescriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'shortDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      shortDescriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'shortDescription',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      shortDescriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'shortDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      shortDescriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'shortDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      shortDescriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'shortDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      shortDescriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'shortDescription',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      shortDescriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shortDescription',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      shortDescriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'shortDescription',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      taxTemplateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taxTemplate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      taxTemplateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taxTemplate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      taxTemplateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taxTemplate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      taxTemplateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taxTemplate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      taxTemplateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'taxTemplate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      taxTemplateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'taxTemplate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      taxTemplateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'taxTemplate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      taxTemplateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'taxTemplate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      taxTemplateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taxTemplate',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      taxTemplateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'taxTemplate',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      vegTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vegType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      vegTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vegType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      vegTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vegType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      vegTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vegType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      vegTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'vegType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      vegTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'vegType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      vegTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'vegType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      vegTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'vegType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      vegTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vegType',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterFilterCondition>
      vegTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'vegType',
        value: '',
      ));
    });
  }
}

extension MenuItemCollectionQueryObject
    on QueryBuilder<MenuItemCollection, MenuItemCollection, QFilterCondition> {}

extension MenuItemCollectionQueryLinks
    on QueryBuilder<MenuItemCollection, MenuItemCollection, QFilterCondition> {}

extension MenuItemCollectionQuerySortBy
    on QueryBuilder<MenuItemCollection, MenuItemCollection, QSortBy> {
  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      sortByCalorificValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calorificValue', Sort.asc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      sortByCalorificValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calorificValue', Sort.desc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      sortByImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.asc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      sortByImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.desc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      sortByIngredients() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ingredients', Sort.asc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      sortByIngredientsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ingredients', Sort.desc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      sortByIsAvailable() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAvailable', Sort.asc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      sortByIsAvailableDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAvailable', Sort.desc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      sortByIsFrequentlySold() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFrequentlySold', Sort.asc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      sortByIsFrequentlySoldDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFrequentlySold', Sort.desc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      sortByItemGroup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemGroup', Sort.asc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      sortByItemGroupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemGroup', Sort.desc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      sortByKitchenCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kitchenCategory', Sort.asc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      sortByKitchenCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kitchenCategory', Sort.desc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      sortByPortion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'portion', Sort.asc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      sortByPortionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'portion', Sort.desc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      sortByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.asc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      sortByPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.desc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      sortByRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.asc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      sortByRemoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.desc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      sortBySalesCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salesCategory', Sort.asc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      sortBySalesCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salesCategory', Sort.desc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      sortByServiceTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serviceTime', Sort.asc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      sortByServiceTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serviceTime', Sort.desc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      sortByShortCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shortCode', Sort.asc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      sortByShortCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shortCode', Sort.desc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      sortByShortDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shortDescription', Sort.asc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      sortByShortDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shortDescription', Sort.desc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      sortByTaxTemplate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxTemplate', Sort.asc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      sortByTaxTemplateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxTemplate', Sort.desc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      sortByVegType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vegType', Sort.asc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      sortByVegTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vegType', Sort.desc);
    });
  }
}

extension MenuItemCollectionQuerySortThenBy
    on QueryBuilder<MenuItemCollection, MenuItemCollection, QSortThenBy> {
  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      thenByCalorificValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calorificValue', Sort.asc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      thenByCalorificValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calorificValue', Sort.desc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      thenByImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.asc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      thenByImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.desc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      thenByIngredients() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ingredients', Sort.asc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      thenByIngredientsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ingredients', Sort.desc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      thenByIsAvailable() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAvailable', Sort.asc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      thenByIsAvailableDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAvailable', Sort.desc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      thenByIsFrequentlySold() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFrequentlySold', Sort.asc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      thenByIsFrequentlySoldDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFrequentlySold', Sort.desc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      thenByItemGroup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemGroup', Sort.asc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      thenByItemGroupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemGroup', Sort.desc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      thenByKitchenCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kitchenCategory', Sort.asc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      thenByKitchenCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kitchenCategory', Sort.desc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      thenByPortion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'portion', Sort.asc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      thenByPortionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'portion', Sort.desc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      thenByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.asc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      thenByPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.desc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      thenByRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.asc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      thenByRemoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.desc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      thenBySalesCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salesCategory', Sort.asc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      thenBySalesCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salesCategory', Sort.desc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      thenByServiceTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serviceTime', Sort.asc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      thenByServiceTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serviceTime', Sort.desc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      thenByShortCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shortCode', Sort.asc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      thenByShortCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shortCode', Sort.desc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      thenByShortDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shortDescription', Sort.asc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      thenByShortDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shortDescription', Sort.desc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      thenByTaxTemplate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxTemplate', Sort.asc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      thenByTaxTemplateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxTemplate', Sort.desc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      thenByVegType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vegType', Sort.asc);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QAfterSortBy>
      thenByVegTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vegType', Sort.desc);
    });
  }
}

extension MenuItemCollectionQueryWhereDistinct
    on QueryBuilder<MenuItemCollection, MenuItemCollection, QDistinct> {
  QueryBuilder<MenuItemCollection, MenuItemCollection, QDistinct>
      distinctByAllergens() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'allergens');
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QDistinct>
      distinctByCalorificValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'calorificValue');
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QDistinct>
      distinctByDietaryTags() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dietaryTags');
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QDistinct>
      distinctByImageUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imageUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QDistinct>
      distinctByIngredients({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ingredients', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QDistinct>
      distinctByIsAvailable() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isAvailable');
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QDistinct>
      distinctByIsFrequentlySold() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isFrequentlySold');
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QDistinct>
      distinctByItemGroup({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemGroup', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QDistinct>
      distinctByKitchenCategory({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'kitchenCategory',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QDistinct>
      distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QDistinct>
      distinctByPortion({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'portion', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QDistinct>
      distinctByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'price');
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QDistinct>
      distinctByRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remoteId');
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QDistinct>
      distinctBySalesCategory({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'salesCategory',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QDistinct>
      distinctByServiceTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serviceTime');
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QDistinct>
      distinctByShortCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shortCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QDistinct>
      distinctByShortDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shortDescription',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QDistinct>
      distinctByTaxTemplate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taxTemplate', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MenuItemCollection, MenuItemCollection, QDistinct>
      distinctByVegType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vegType', caseSensitive: caseSensitive);
    });
  }
}

extension MenuItemCollectionQueryProperty
    on QueryBuilder<MenuItemCollection, MenuItemCollection, QQueryProperty> {
  QueryBuilder<MenuItemCollection, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MenuItemCollection, List<String>?, QQueryOperations>
      allergensProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'allergens');
    });
  }

  QueryBuilder<MenuItemCollection, int?, QQueryOperations>
      calorificValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'calorificValue');
    });
  }

  QueryBuilder<MenuItemCollection, List<String>?, QQueryOperations>
      dietaryTagsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dietaryTags');
    });
  }

  QueryBuilder<MenuItemCollection, String?, QQueryOperations>
      imageUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imageUrl');
    });
  }

  QueryBuilder<MenuItemCollection, String?, QQueryOperations>
      ingredientsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ingredients');
    });
  }

  QueryBuilder<MenuItemCollection, bool, QQueryOperations>
      isAvailableProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isAvailable');
    });
  }

  QueryBuilder<MenuItemCollection, bool, QQueryOperations>
      isFrequentlySoldProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isFrequentlySold');
    });
  }

  QueryBuilder<MenuItemCollection, String, QQueryOperations>
      itemGroupProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemGroup');
    });
  }

  QueryBuilder<MenuItemCollection, String?, QQueryOperations>
      kitchenCategoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'kitchenCategory');
    });
  }

  QueryBuilder<MenuItemCollection, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<MenuItemCollection, String?, QQueryOperations>
      portionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'portion');
    });
  }

  QueryBuilder<MenuItemCollection, double, QQueryOperations> priceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'price');
    });
  }

  QueryBuilder<MenuItemCollection, int, QQueryOperations> remoteIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remoteId');
    });
  }

  QueryBuilder<MenuItemCollection, String?, QQueryOperations>
      salesCategoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'salesCategory');
    });
  }

  QueryBuilder<MenuItemCollection, int?, QQueryOperations>
      serviceTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serviceTime');
    });
  }

  QueryBuilder<MenuItemCollection, String, QQueryOperations>
      shortCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shortCode');
    });
  }

  QueryBuilder<MenuItemCollection, String?, QQueryOperations>
      shortDescriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shortDescription');
    });
  }

  QueryBuilder<MenuItemCollection, String, QQueryOperations>
      taxTemplateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taxTemplate');
    });
  }

  QueryBuilder<MenuItemCollection, String, QQueryOperations> vegTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vegType');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMenuTemplateCollectionCollection on Isar {
  IsarCollection<MenuTemplateCollection> get menuTemplateCollections =>
      this.collection();
}

const MenuTemplateCollectionSchema = CollectionSchema(
  name: r'MenuTemplateCollection',
  id: 1793760336278176919,
  properties: {
    r'backgroundColor': PropertySchema(
      id: 0,
      name: r'backgroundColor',
      type: IsarType.string,
    ),
    r'isActive': PropertySchema(
      id: 1,
      name: r'isActive',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(
      id: 2,
      name: r'name',
      type: IsarType.string,
    ),
    r'primaryColor': PropertySchema(
      id: 3,
      name: r'primaryColor',
      type: IsarType.string,
    ),
    r'remoteId': PropertySchema(
      id: 4,
      name: r'remoteId',
      type: IsarType.long,
    ),
    r'textColor': PropertySchema(
      id: 5,
      name: r'textColor',
      type: IsarType.string,
    )
  },
  estimateSize: _menuTemplateCollectionEstimateSize,
  serialize: _menuTemplateCollectionSerialize,
  deserialize: _menuTemplateCollectionDeserialize,
  deserializeProp: _menuTemplateCollectionDeserializeProp,
  idName: r'id',
  indexes: {
    r'remoteId': IndexSchema(
      id: 6301175856541681032,
      name: r'remoteId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'remoteId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _menuTemplateCollectionGetId,
  getLinks: _menuTemplateCollectionGetLinks,
  attach: _menuTemplateCollectionAttach,
  version: '3.1.0+1',
);

int _menuTemplateCollectionEstimateSize(
  MenuTemplateCollection object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.backgroundColor.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.primaryColor.length * 3;
  bytesCount += 3 + object.textColor.length * 3;
  return bytesCount;
}

void _menuTemplateCollectionSerialize(
  MenuTemplateCollection object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.backgroundColor);
  writer.writeBool(offsets[1], object.isActive);
  writer.writeString(offsets[2], object.name);
  writer.writeString(offsets[3], object.primaryColor);
  writer.writeLong(offsets[4], object.remoteId);
  writer.writeString(offsets[5], object.textColor);
}

MenuTemplateCollection _menuTemplateCollectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MenuTemplateCollection();
  object.backgroundColor = reader.readString(offsets[0]);
  object.id = id;
  object.isActive = reader.readBool(offsets[1]);
  object.name = reader.readString(offsets[2]);
  object.primaryColor = reader.readString(offsets[3]);
  object.remoteId = reader.readLong(offsets[4]);
  object.textColor = reader.readString(offsets[5]);
  return object;
}

P _menuTemplateCollectionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _menuTemplateCollectionGetId(MenuTemplateCollection object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _menuTemplateCollectionGetLinks(
    MenuTemplateCollection object) {
  return [];
}

void _menuTemplateCollectionAttach(
    IsarCollection<dynamic> col, Id id, MenuTemplateCollection object) {
  object.id = id;
}

extension MenuTemplateCollectionByIndex
    on IsarCollection<MenuTemplateCollection> {
  Future<MenuTemplateCollection?> getByRemoteId(int remoteId) {
    return getByIndex(r'remoteId', [remoteId]);
  }

  MenuTemplateCollection? getByRemoteIdSync(int remoteId) {
    return getByIndexSync(r'remoteId', [remoteId]);
  }

  Future<bool> deleteByRemoteId(int remoteId) {
    return deleteByIndex(r'remoteId', [remoteId]);
  }

  bool deleteByRemoteIdSync(int remoteId) {
    return deleteByIndexSync(r'remoteId', [remoteId]);
  }

  Future<List<MenuTemplateCollection?>> getAllByRemoteId(
      List<int> remoteIdValues) {
    final values = remoteIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'remoteId', values);
  }

  List<MenuTemplateCollection?> getAllByRemoteIdSync(List<int> remoteIdValues) {
    final values = remoteIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'remoteId', values);
  }

  Future<int> deleteAllByRemoteId(List<int> remoteIdValues) {
    final values = remoteIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'remoteId', values);
  }

  int deleteAllByRemoteIdSync(List<int> remoteIdValues) {
    final values = remoteIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'remoteId', values);
  }

  Future<Id> putByRemoteId(MenuTemplateCollection object) {
    return putByIndex(r'remoteId', object);
  }

  Id putByRemoteIdSync(MenuTemplateCollection object, {bool saveLinks = true}) {
    return putByIndexSync(r'remoteId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByRemoteId(List<MenuTemplateCollection> objects) {
    return putAllByIndex(r'remoteId', objects);
  }

  List<Id> putAllByRemoteIdSync(List<MenuTemplateCollection> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'remoteId', objects, saveLinks: saveLinks);
  }
}

extension MenuTemplateCollectionQueryWhereSort
    on QueryBuilder<MenuTemplateCollection, MenuTemplateCollection, QWhere> {
  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection, QAfterWhere>
      anyRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'remoteId'),
      );
    });
  }
}

extension MenuTemplateCollectionQueryWhere on QueryBuilder<
    MenuTemplateCollection, MenuTemplateCollection, QWhereClause> {
  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterWhereClause> remoteIdEqualTo(int remoteId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'remoteId',
        value: [remoteId],
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterWhereClause> remoteIdNotEqualTo(int remoteId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'remoteId',
              lower: [],
              upper: [remoteId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'remoteId',
              lower: [remoteId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'remoteId',
              lower: [remoteId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'remoteId',
              lower: [],
              upper: [remoteId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterWhereClause> remoteIdGreaterThan(
    int remoteId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'remoteId',
        lower: [remoteId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterWhereClause> remoteIdLessThan(
    int remoteId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'remoteId',
        lower: [],
        upper: [remoteId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterWhereClause> remoteIdBetween(
    int lowerRemoteId,
    int upperRemoteId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'remoteId',
        lower: [lowerRemoteId],
        includeLower: includeLower,
        upper: [upperRemoteId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MenuTemplateCollectionQueryFilter on QueryBuilder<
    MenuTemplateCollection, MenuTemplateCollection, QFilterCondition> {
  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterFilterCondition> backgroundColorEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'backgroundColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterFilterCondition> backgroundColorGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'backgroundColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterFilterCondition> backgroundColorLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'backgroundColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterFilterCondition> backgroundColorBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'backgroundColor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterFilterCondition> backgroundColorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'backgroundColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterFilterCondition> backgroundColorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'backgroundColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
          QAfterFilterCondition>
      backgroundColorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'backgroundColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
          QAfterFilterCondition>
      backgroundColorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'backgroundColor',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterFilterCondition> backgroundColorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'backgroundColor',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterFilterCondition> backgroundColorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'backgroundColor',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterFilterCondition> isActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isActive',
        value: value,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
          QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
          QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterFilterCondition> primaryColorEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'primaryColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterFilterCondition> primaryColorGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'primaryColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterFilterCondition> primaryColorLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'primaryColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterFilterCondition> primaryColorBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'primaryColor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterFilterCondition> primaryColorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'primaryColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterFilterCondition> primaryColorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'primaryColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
          QAfterFilterCondition>
      primaryColorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'primaryColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
          QAfterFilterCondition>
      primaryColorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'primaryColor',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterFilterCondition> primaryColorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'primaryColor',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterFilterCondition> primaryColorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'primaryColor',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterFilterCondition> remoteIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remoteId',
        value: value,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterFilterCondition> remoteIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'remoteId',
        value: value,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterFilterCondition> remoteIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'remoteId',
        value: value,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterFilterCondition> remoteIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'remoteId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterFilterCondition> textColorEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'textColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterFilterCondition> textColorGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'textColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterFilterCondition> textColorLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'textColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterFilterCondition> textColorBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'textColor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterFilterCondition> textColorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'textColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterFilterCondition> textColorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'textColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
          QAfterFilterCondition>
      textColorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'textColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
          QAfterFilterCondition>
      textColorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'textColor',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterFilterCondition> textColorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'textColor',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection,
      QAfterFilterCondition> textColorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'textColor',
        value: '',
      ));
    });
  }
}

extension MenuTemplateCollectionQueryObject on QueryBuilder<
    MenuTemplateCollection, MenuTemplateCollection, QFilterCondition> {}

extension MenuTemplateCollectionQueryLinks on QueryBuilder<
    MenuTemplateCollection, MenuTemplateCollection, QFilterCondition> {}

extension MenuTemplateCollectionQuerySortBy
    on QueryBuilder<MenuTemplateCollection, MenuTemplateCollection, QSortBy> {
  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection, QAfterSortBy>
      sortByBackgroundColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backgroundColor', Sort.asc);
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection, QAfterSortBy>
      sortByBackgroundColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backgroundColor', Sort.desc);
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection, QAfterSortBy>
      sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection, QAfterSortBy>
      sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection, QAfterSortBy>
      sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection, QAfterSortBy>
      sortByPrimaryColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryColor', Sort.asc);
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection, QAfterSortBy>
      sortByPrimaryColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryColor', Sort.desc);
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection, QAfterSortBy>
      sortByRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.asc);
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection, QAfterSortBy>
      sortByRemoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.desc);
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection, QAfterSortBy>
      sortByTextColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textColor', Sort.asc);
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection, QAfterSortBy>
      sortByTextColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textColor', Sort.desc);
    });
  }
}

extension MenuTemplateCollectionQuerySortThenBy on QueryBuilder<
    MenuTemplateCollection, MenuTemplateCollection, QSortThenBy> {
  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection, QAfterSortBy>
      thenByBackgroundColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backgroundColor', Sort.asc);
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection, QAfterSortBy>
      thenByBackgroundColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backgroundColor', Sort.desc);
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection, QAfterSortBy>
      thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection, QAfterSortBy>
      thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection, QAfterSortBy>
      thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection, QAfterSortBy>
      thenByPrimaryColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryColor', Sort.asc);
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection, QAfterSortBy>
      thenByPrimaryColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryColor', Sort.desc);
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection, QAfterSortBy>
      thenByRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.asc);
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection, QAfterSortBy>
      thenByRemoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.desc);
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection, QAfterSortBy>
      thenByTextColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textColor', Sort.asc);
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection, QAfterSortBy>
      thenByTextColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textColor', Sort.desc);
    });
  }
}

extension MenuTemplateCollectionQueryWhereDistinct
    on QueryBuilder<MenuTemplateCollection, MenuTemplateCollection, QDistinct> {
  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection, QDistinct>
      distinctByBackgroundColor({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'backgroundColor',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection, QDistinct>
      distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection, QDistinct>
      distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection, QDistinct>
      distinctByPrimaryColor({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'primaryColor', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection, QDistinct>
      distinctByRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remoteId');
    });
  }

  QueryBuilder<MenuTemplateCollection, MenuTemplateCollection, QDistinct>
      distinctByTextColor({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'textColor', caseSensitive: caseSensitive);
    });
  }
}

extension MenuTemplateCollectionQueryProperty on QueryBuilder<
    MenuTemplateCollection, MenuTemplateCollection, QQueryProperty> {
  QueryBuilder<MenuTemplateCollection, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MenuTemplateCollection, String, QQueryOperations>
      backgroundColorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'backgroundColor');
    });
  }

  QueryBuilder<MenuTemplateCollection, bool, QQueryOperations>
      isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<MenuTemplateCollection, String, QQueryOperations>
      nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<MenuTemplateCollection, String, QQueryOperations>
      primaryColorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'primaryColor');
    });
  }

  QueryBuilder<MenuTemplateCollection, int, QQueryOperations>
      remoteIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remoteId');
    });
  }

  QueryBuilder<MenuTemplateCollection, String, QQueryOperations>
      textColorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'textColor');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMenuSessionCollectionCollection on Isar {
  IsarCollection<MenuSessionCollection> get menuSessionCollections =>
      this.collection();
}

const MenuSessionCollectionSchema = CollectionSchema(
  name: r'MenuSessionCollection',
  id: 5590373090457974184,
  properties: {
    r'endTime': PropertySchema(
      id: 0,
      name: r'endTime',
      type: IsarType.string,
    ),
    r'isActive': PropertySchema(
      id: 1,
      name: r'isActive',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(
      id: 2,
      name: r'name',
      type: IsarType.string,
    ),
    r'offerDescription': PropertySchema(
      id: 3,
      name: r'offerDescription',
      type: IsarType.string,
    ),
    r'offerImageUrl': PropertySchema(
      id: 4,
      name: r'offerImageUrl',
      type: IsarType.string,
    ),
    r'remoteId': PropertySchema(
      id: 5,
      name: r'remoteId',
      type: IsarType.long,
    ),
    r'splashImageUrl': PropertySchema(
      id: 6,
      name: r'splashImageUrl',
      type: IsarType.string,
    ),
    r'startTime': PropertySchema(
      id: 7,
      name: r'startTime',
      type: IsarType.string,
    )
  },
  estimateSize: _menuSessionCollectionEstimateSize,
  serialize: _menuSessionCollectionSerialize,
  deserialize: _menuSessionCollectionDeserialize,
  deserializeProp: _menuSessionCollectionDeserializeProp,
  idName: r'id',
  indexes: {
    r'remoteId': IndexSchema(
      id: 6301175856541681032,
      name: r'remoteId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'remoteId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _menuSessionCollectionGetId,
  getLinks: _menuSessionCollectionGetLinks,
  attach: _menuSessionCollectionAttach,
  version: '3.1.0+1',
);

int _menuSessionCollectionEstimateSize(
  MenuSessionCollection object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.endTime.length * 3;
  bytesCount += 3 + object.name.length * 3;
  {
    final value = object.offerDescription;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.offerImageUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.splashImageUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.startTime.length * 3;
  return bytesCount;
}

void _menuSessionCollectionSerialize(
  MenuSessionCollection object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.endTime);
  writer.writeBool(offsets[1], object.isActive);
  writer.writeString(offsets[2], object.name);
  writer.writeString(offsets[3], object.offerDescription);
  writer.writeString(offsets[4], object.offerImageUrl);
  writer.writeLong(offsets[5], object.remoteId);
  writer.writeString(offsets[6], object.splashImageUrl);
  writer.writeString(offsets[7], object.startTime);
}

MenuSessionCollection _menuSessionCollectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MenuSessionCollection();
  object.endTime = reader.readString(offsets[0]);
  object.id = id;
  object.isActive = reader.readBool(offsets[1]);
  object.name = reader.readString(offsets[2]);
  object.offerDescription = reader.readStringOrNull(offsets[3]);
  object.offerImageUrl = reader.readStringOrNull(offsets[4]);
  object.remoteId = reader.readLong(offsets[5]);
  object.splashImageUrl = reader.readStringOrNull(offsets[6]);
  object.startTime = reader.readString(offsets[7]);
  return object;
}

P _menuSessionCollectionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _menuSessionCollectionGetId(MenuSessionCollection object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _menuSessionCollectionGetLinks(
    MenuSessionCollection object) {
  return [];
}

void _menuSessionCollectionAttach(
    IsarCollection<dynamic> col, Id id, MenuSessionCollection object) {
  object.id = id;
}

extension MenuSessionCollectionByIndex
    on IsarCollection<MenuSessionCollection> {
  Future<MenuSessionCollection?> getByRemoteId(int remoteId) {
    return getByIndex(r'remoteId', [remoteId]);
  }

  MenuSessionCollection? getByRemoteIdSync(int remoteId) {
    return getByIndexSync(r'remoteId', [remoteId]);
  }

  Future<bool> deleteByRemoteId(int remoteId) {
    return deleteByIndex(r'remoteId', [remoteId]);
  }

  bool deleteByRemoteIdSync(int remoteId) {
    return deleteByIndexSync(r'remoteId', [remoteId]);
  }

  Future<List<MenuSessionCollection?>> getAllByRemoteId(
      List<int> remoteIdValues) {
    final values = remoteIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'remoteId', values);
  }

  List<MenuSessionCollection?> getAllByRemoteIdSync(List<int> remoteIdValues) {
    final values = remoteIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'remoteId', values);
  }

  Future<int> deleteAllByRemoteId(List<int> remoteIdValues) {
    final values = remoteIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'remoteId', values);
  }

  int deleteAllByRemoteIdSync(List<int> remoteIdValues) {
    final values = remoteIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'remoteId', values);
  }

  Future<Id> putByRemoteId(MenuSessionCollection object) {
    return putByIndex(r'remoteId', object);
  }

  Id putByRemoteIdSync(MenuSessionCollection object, {bool saveLinks = true}) {
    return putByIndexSync(r'remoteId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByRemoteId(List<MenuSessionCollection> objects) {
    return putAllByIndex(r'remoteId', objects);
  }

  List<Id> putAllByRemoteIdSync(List<MenuSessionCollection> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'remoteId', objects, saveLinks: saveLinks);
  }
}

extension MenuSessionCollectionQueryWhereSort
    on QueryBuilder<MenuSessionCollection, MenuSessionCollection, QWhere> {
  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterWhere>
      anyRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'remoteId'),
      );
    });
  }
}

extension MenuSessionCollectionQueryWhere on QueryBuilder<MenuSessionCollection,
    MenuSessionCollection, QWhereClause> {
  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterWhereClause>
      remoteIdEqualTo(int remoteId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'remoteId',
        value: [remoteId],
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterWhereClause>
      remoteIdNotEqualTo(int remoteId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'remoteId',
              lower: [],
              upper: [remoteId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'remoteId',
              lower: [remoteId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'remoteId',
              lower: [remoteId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'remoteId',
              lower: [],
              upper: [remoteId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterWhereClause>
      remoteIdGreaterThan(
    int remoteId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'remoteId',
        lower: [remoteId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterWhereClause>
      remoteIdLessThan(
    int remoteId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'remoteId',
        lower: [],
        upper: [remoteId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterWhereClause>
      remoteIdBetween(
    int lowerRemoteId,
    int upperRemoteId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'remoteId',
        lower: [lowerRemoteId],
        includeLower: includeLower,
        upper: [upperRemoteId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MenuSessionCollectionQueryFilter on QueryBuilder<
    MenuSessionCollection, MenuSessionCollection, QFilterCondition> {
  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> endTimeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> endTimeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> endTimeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> endTimeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> endTimeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'endTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> endTimeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'endTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
          QAfterFilterCondition>
      endTimeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'endTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
          QAfterFilterCondition>
      endTimeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'endTime',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> endTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endTime',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> endTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'endTime',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> isActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isActive',
        value: value,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
          QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
          QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> offerDescriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'offerDescription',
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> offerDescriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'offerDescription',
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> offerDescriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'offerDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> offerDescriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'offerDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> offerDescriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'offerDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> offerDescriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'offerDescription',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> offerDescriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'offerDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> offerDescriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'offerDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
          QAfterFilterCondition>
      offerDescriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'offerDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
          QAfterFilterCondition>
      offerDescriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'offerDescription',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> offerDescriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'offerDescription',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> offerDescriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'offerDescription',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> offerImageUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'offerImageUrl',
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> offerImageUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'offerImageUrl',
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> offerImageUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'offerImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> offerImageUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'offerImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> offerImageUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'offerImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> offerImageUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'offerImageUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> offerImageUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'offerImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> offerImageUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'offerImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
          QAfterFilterCondition>
      offerImageUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'offerImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
          QAfterFilterCondition>
      offerImageUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'offerImageUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> offerImageUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'offerImageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> offerImageUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'offerImageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> remoteIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remoteId',
        value: value,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> remoteIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'remoteId',
        value: value,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> remoteIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'remoteId',
        value: value,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> remoteIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'remoteId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> splashImageUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'splashImageUrl',
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> splashImageUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'splashImageUrl',
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> splashImageUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'splashImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> splashImageUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'splashImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> splashImageUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'splashImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> splashImageUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'splashImageUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> splashImageUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'splashImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> splashImageUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'splashImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
          QAfterFilterCondition>
      splashImageUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'splashImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
          QAfterFilterCondition>
      splashImageUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'splashImageUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> splashImageUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'splashImageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> splashImageUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'splashImageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> startTimeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> startTimeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> startTimeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> startTimeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> startTimeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'startTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> startTimeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'startTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
          QAfterFilterCondition>
      startTimeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'startTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
          QAfterFilterCondition>
      startTimeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'startTime',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> startTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startTime',
        value: '',
      ));
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection,
      QAfterFilterCondition> startTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'startTime',
        value: '',
      ));
    });
  }
}

extension MenuSessionCollectionQueryObject on QueryBuilder<
    MenuSessionCollection, MenuSessionCollection, QFilterCondition> {}

extension MenuSessionCollectionQueryLinks on QueryBuilder<MenuSessionCollection,
    MenuSessionCollection, QFilterCondition> {}

extension MenuSessionCollectionQuerySortBy
    on QueryBuilder<MenuSessionCollection, MenuSessionCollection, QSortBy> {
  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterSortBy>
      sortByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterSortBy>
      sortByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterSortBy>
      sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterSortBy>
      sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterSortBy>
      sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterSortBy>
      sortByOfferDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'offerDescription', Sort.asc);
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterSortBy>
      sortByOfferDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'offerDescription', Sort.desc);
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterSortBy>
      sortByOfferImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'offerImageUrl', Sort.asc);
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterSortBy>
      sortByOfferImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'offerImageUrl', Sort.desc);
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterSortBy>
      sortByRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.asc);
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterSortBy>
      sortByRemoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.desc);
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterSortBy>
      sortBySplashImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'splashImageUrl', Sort.asc);
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterSortBy>
      sortBySplashImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'splashImageUrl', Sort.desc);
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterSortBy>
      sortByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterSortBy>
      sortByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }
}

extension MenuSessionCollectionQuerySortThenBy
    on QueryBuilder<MenuSessionCollection, MenuSessionCollection, QSortThenBy> {
  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterSortBy>
      thenByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterSortBy>
      thenByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterSortBy>
      thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterSortBy>
      thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterSortBy>
      thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterSortBy>
      thenByOfferDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'offerDescription', Sort.asc);
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterSortBy>
      thenByOfferDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'offerDescription', Sort.desc);
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterSortBy>
      thenByOfferImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'offerImageUrl', Sort.asc);
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterSortBy>
      thenByOfferImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'offerImageUrl', Sort.desc);
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterSortBy>
      thenByRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.asc);
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterSortBy>
      thenByRemoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.desc);
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterSortBy>
      thenBySplashImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'splashImageUrl', Sort.asc);
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterSortBy>
      thenBySplashImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'splashImageUrl', Sort.desc);
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterSortBy>
      thenByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QAfterSortBy>
      thenByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }
}

extension MenuSessionCollectionQueryWhereDistinct
    on QueryBuilder<MenuSessionCollection, MenuSessionCollection, QDistinct> {
  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QDistinct>
      distinctByEndTime({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endTime', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QDistinct>
      distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QDistinct>
      distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QDistinct>
      distinctByOfferDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'offerDescription',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QDistinct>
      distinctByOfferImageUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'offerImageUrl',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QDistinct>
      distinctByRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remoteId');
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QDistinct>
      distinctBySplashImageUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'splashImageUrl',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MenuSessionCollection, MenuSessionCollection, QDistinct>
      distinctByStartTime({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startTime', caseSensitive: caseSensitive);
    });
  }
}

extension MenuSessionCollectionQueryProperty on QueryBuilder<
    MenuSessionCollection, MenuSessionCollection, QQueryProperty> {
  QueryBuilder<MenuSessionCollection, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MenuSessionCollection, String, QQueryOperations>
      endTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endTime');
    });
  }

  QueryBuilder<MenuSessionCollection, bool, QQueryOperations>
      isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<MenuSessionCollection, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<MenuSessionCollection, String?, QQueryOperations>
      offerDescriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'offerDescription');
    });
  }

  QueryBuilder<MenuSessionCollection, String?, QQueryOperations>
      offerImageUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'offerImageUrl');
    });
  }

  QueryBuilder<MenuSessionCollection, int, QQueryOperations>
      remoteIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remoteId');
    });
  }

  QueryBuilder<MenuSessionCollection, String?, QQueryOperations>
      splashImageUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'splashImageUrl');
    });
  }

  QueryBuilder<MenuSessionCollection, String, QQueryOperations>
      startTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startTime');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDashboardAnalyticsCollectionCollection on Isar {
  IsarCollection<DashboardAnalyticsCollection>
      get dashboardAnalyticsCollections => this.collection();
}

const DashboardAnalyticsCollectionSchema = CollectionSchema(
  name: r'DashboardAnalyticsCollection',
  id: -7557943059240856550,
  properties: {
    r'lastUpdatedTime': PropertySchema(
      id: 0,
      name: r'lastUpdatedTime',
      type: IsarType.long,
    ),
    r'period': PropertySchema(
      id: 1,
      name: r'period',
      type: IsarType.string,
    ),
    r'scanChartData': PropertySchema(
      id: 2,
      name: r'scanChartData',
      type: IsarType.longList,
    ),
    r'scanChartLabels': PropertySchema(
      id: 3,
      name: r'scanChartLabels',
      type: IsarType.stringList,
    ),
    r'totalScans': PropertySchema(
      id: 4,
      name: r'totalScans',
      type: IsarType.long,
    )
  },
  estimateSize: _dashboardAnalyticsCollectionEstimateSize,
  serialize: _dashboardAnalyticsCollectionSerialize,
  deserialize: _dashboardAnalyticsCollectionDeserialize,
  deserializeProp: _dashboardAnalyticsCollectionDeserializeProp,
  idName: r'id',
  indexes: {
    r'period': IndexSchema(
      id: -1253107732758621689,
      name: r'period',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'period',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _dashboardAnalyticsCollectionGetId,
  getLinks: _dashboardAnalyticsCollectionGetLinks,
  attach: _dashboardAnalyticsCollectionAttach,
  version: '3.1.0+1',
);

int _dashboardAnalyticsCollectionEstimateSize(
  DashboardAnalyticsCollection object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.period.length * 3;
  bytesCount += 3 + object.scanChartData.length * 8;
  bytesCount += 3 + object.scanChartLabels.length * 3;
  {
    for (var i = 0; i < object.scanChartLabels.length; i++) {
      final value = object.scanChartLabels[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _dashboardAnalyticsCollectionSerialize(
  DashboardAnalyticsCollection object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.lastUpdatedTime);
  writer.writeString(offsets[1], object.period);
  writer.writeLongList(offsets[2], object.scanChartData);
  writer.writeStringList(offsets[3], object.scanChartLabels);
  writer.writeLong(offsets[4], object.totalScans);
}

DashboardAnalyticsCollection _dashboardAnalyticsCollectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DashboardAnalyticsCollection();
  object.id = id;
  object.lastUpdatedTime = reader.readLong(offsets[0]);
  object.period = reader.readString(offsets[1]);
  object.scanChartData = reader.readLongList(offsets[2]) ?? [];
  object.scanChartLabels = reader.readStringList(offsets[3]) ?? [];
  object.totalScans = reader.readLong(offsets[4]);
  return object;
}

P _dashboardAnalyticsCollectionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLongList(offset) ?? []) as P;
    case 3:
      return (reader.readStringList(offset) ?? []) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dashboardAnalyticsCollectionGetId(DashboardAnalyticsCollection object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _dashboardAnalyticsCollectionGetLinks(
    DashboardAnalyticsCollection object) {
  return [];
}

void _dashboardAnalyticsCollectionAttach(
    IsarCollection<dynamic> col, Id id, DashboardAnalyticsCollection object) {
  object.id = id;
}

extension DashboardAnalyticsCollectionByIndex
    on IsarCollection<DashboardAnalyticsCollection> {
  Future<DashboardAnalyticsCollection?> getByPeriod(String period) {
    return getByIndex(r'period', [period]);
  }

  DashboardAnalyticsCollection? getByPeriodSync(String period) {
    return getByIndexSync(r'period', [period]);
  }

  Future<bool> deleteByPeriod(String period) {
    return deleteByIndex(r'period', [period]);
  }

  bool deleteByPeriodSync(String period) {
    return deleteByIndexSync(r'period', [period]);
  }

  Future<List<DashboardAnalyticsCollection?>> getAllByPeriod(
      List<String> periodValues) {
    final values = periodValues.map((e) => [e]).toList();
    return getAllByIndex(r'period', values);
  }

  List<DashboardAnalyticsCollection?> getAllByPeriodSync(
      List<String> periodValues) {
    final values = periodValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'period', values);
  }

  Future<int> deleteAllByPeriod(List<String> periodValues) {
    final values = periodValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'period', values);
  }

  int deleteAllByPeriodSync(List<String> periodValues) {
    final values = periodValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'period', values);
  }

  Future<Id> putByPeriod(DashboardAnalyticsCollection object) {
    return putByIndex(r'period', object);
  }

  Id putByPeriodSync(DashboardAnalyticsCollection object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'period', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByPeriod(List<DashboardAnalyticsCollection> objects) {
    return putAllByIndex(r'period', objects);
  }

  List<Id> putAllByPeriodSync(List<DashboardAnalyticsCollection> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'period', objects, saveLinks: saveLinks);
  }
}

extension DashboardAnalyticsCollectionQueryWhereSort on QueryBuilder<
    DashboardAnalyticsCollection, DashboardAnalyticsCollection, QWhere> {
  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DashboardAnalyticsCollectionQueryWhere on QueryBuilder<
    DashboardAnalyticsCollection, DashboardAnalyticsCollection, QWhereClause> {
  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterWhereClause> periodEqualTo(String period) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'period',
        value: [period],
      ));
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterWhereClause> periodNotEqualTo(String period) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'period',
              lower: [],
              upper: [period],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'period',
              lower: [period],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'period',
              lower: [period],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'period',
              lower: [],
              upper: [period],
              includeUpper: false,
            ));
      }
    });
  }
}

extension DashboardAnalyticsCollectionQueryFilter on QueryBuilder<
    DashboardAnalyticsCollection,
    DashboardAnalyticsCollection,
    QFilterCondition> {
  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> lastUpdatedTimeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUpdatedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> lastUpdatedTimeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastUpdatedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> lastUpdatedTimeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastUpdatedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> lastUpdatedTimeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastUpdatedTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> periodEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'period',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> periodGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'period',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> periodLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'period',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> periodBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'period',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> periodStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'period',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> periodEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'period',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
          QAfterFilterCondition>
      periodContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'period',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
          QAfterFilterCondition>
      periodMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'period',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> periodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'period',
        value: '',
      ));
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> periodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'period',
        value: '',
      ));
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> scanChartDataElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scanChartData',
        value: value,
      ));
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> scanChartDataElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scanChartData',
        value: value,
      ));
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> scanChartDataElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scanChartData',
        value: value,
      ));
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> scanChartDataElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scanChartData',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> scanChartDataLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'scanChartData',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> scanChartDataIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'scanChartData',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> scanChartDataIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'scanChartData',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> scanChartDataLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'scanChartData',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> scanChartDataLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'scanChartData',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> scanChartDataLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'scanChartData',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> scanChartLabelsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scanChartLabels',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> scanChartLabelsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scanChartLabels',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> scanChartLabelsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scanChartLabels',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> scanChartLabelsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scanChartLabels',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> scanChartLabelsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'scanChartLabels',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> scanChartLabelsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'scanChartLabels',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
          QAfterFilterCondition>
      scanChartLabelsElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'scanChartLabels',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
          QAfterFilterCondition>
      scanChartLabelsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'scanChartLabels',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> scanChartLabelsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scanChartLabels',
        value: '',
      ));
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> scanChartLabelsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'scanChartLabels',
        value: '',
      ));
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> scanChartLabelsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'scanChartLabels',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> scanChartLabelsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'scanChartLabels',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> scanChartLabelsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'scanChartLabels',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> scanChartLabelsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'scanChartLabels',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> scanChartLabelsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'scanChartLabels',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> scanChartLabelsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'scanChartLabels',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> totalScansEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalScans',
        value: value,
      ));
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> totalScansGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalScans',
        value: value,
      ));
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> totalScansLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalScans',
        value: value,
      ));
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterFilterCondition> totalScansBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalScans',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DashboardAnalyticsCollectionQueryObject on QueryBuilder<
    DashboardAnalyticsCollection,
    DashboardAnalyticsCollection,
    QFilterCondition> {}

extension DashboardAnalyticsCollectionQueryLinks on QueryBuilder<
    DashboardAnalyticsCollection,
    DashboardAnalyticsCollection,
    QFilterCondition> {}

extension DashboardAnalyticsCollectionQuerySortBy on QueryBuilder<
    DashboardAnalyticsCollection, DashboardAnalyticsCollection, QSortBy> {
  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterSortBy> sortByLastUpdatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdatedTime', Sort.asc);
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterSortBy> sortByLastUpdatedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdatedTime', Sort.desc);
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterSortBy> sortByPeriod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'period', Sort.asc);
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterSortBy> sortByPeriodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'period', Sort.desc);
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterSortBy> sortByTotalScans() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalScans', Sort.asc);
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterSortBy> sortByTotalScansDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalScans', Sort.desc);
    });
  }
}

extension DashboardAnalyticsCollectionQuerySortThenBy on QueryBuilder<
    DashboardAnalyticsCollection, DashboardAnalyticsCollection, QSortThenBy> {
  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterSortBy> thenByLastUpdatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdatedTime', Sort.asc);
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterSortBy> thenByLastUpdatedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdatedTime', Sort.desc);
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterSortBy> thenByPeriod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'period', Sort.asc);
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterSortBy> thenByPeriodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'period', Sort.desc);
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterSortBy> thenByTotalScans() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalScans', Sort.asc);
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QAfterSortBy> thenByTotalScansDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalScans', Sort.desc);
    });
  }
}

extension DashboardAnalyticsCollectionQueryWhereDistinct on QueryBuilder<
    DashboardAnalyticsCollection, DashboardAnalyticsCollection, QDistinct> {
  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QDistinct> distinctByLastUpdatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUpdatedTime');
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QDistinct> distinctByPeriod({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'period', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QDistinct> distinctByScanChartData() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scanChartData');
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QDistinct> distinctByScanChartLabels() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scanChartLabels');
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, DashboardAnalyticsCollection,
      QDistinct> distinctByTotalScans() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalScans');
    });
  }
}

extension DashboardAnalyticsCollectionQueryProperty on QueryBuilder<
    DashboardAnalyticsCollection,
    DashboardAnalyticsCollection,
    QQueryProperty> {
  QueryBuilder<DashboardAnalyticsCollection, int, QQueryOperations>
      idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, int, QQueryOperations>
      lastUpdatedTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUpdatedTime');
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, String, QQueryOperations>
      periodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'period');
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, List<int>, QQueryOperations>
      scanChartDataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scanChartData');
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, List<String>, QQueryOperations>
      scanChartLabelsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scanChartLabels');
    });
  }

  QueryBuilder<DashboardAnalyticsCollection, int, QQueryOperations>
      totalScansProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalScans');
    });
  }
}
