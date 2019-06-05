# 一个复杂Json解析的例子

> 官方示例代码 https://flutter.dev/docs/cookbook/networking/background-parsing

1. 先来看一个Json数据
   
   ```Json
         {
          "businessInfos" : [
          {
            "storeInfo" : {
              "address" : "31路;32路;60路;86路;134路;154路;260路;(停运)B21路",
              "cityId" : 304,
              "storeType" : 0,
              "storeName" : "昆明市驿站",
              "storeId" : 36716,
              "cityName" : "昆明市",
              "deptType" : 5
            },
            "businessName" : "驿站",
            "menuInfos" : [
              {
                "menuGroupName" : "驿站",
                "menuGroupCode" : "011004000000000000",
                "subMenuInfos" : [
                  {
                    "icon" : "",
                    "count" : 0,
                    "menuCode" : "011004004001000000",
                    "idx" : 1,
                    "menuName" : "我的进行中试驾单"
                  },
                  {
                    "icon" : "",
                    "count" : -1,
                    "menuCode" : "011004007001000000",
                    "idx" : 2,
                    "menuName" : "全部试驾单"
                  },
                  {
                    "icon" : "",
                    "count" : 0,
                    "menuCode" : "011004005001000000",
                    "idx" : 3,
                    "menuName" : "待试驾"
                  },
                  {
                    "icon" : "",
                    "count" : 0,
                    "menuCode" : "011004006001000000",
                    "idx" : 4,
                    "menuName" : "试驾中"
                  }
                ]
              }
            ],
            "businessId" : "STAGE"
          }
        ],
        "accountInfo" : {
          "viewDataAccess" : "0,1",
          "operDataAccess" : "0,1"
        },
        "buttonCodes" : [
          "011001000000000000",
          "011001002001001004",
          "011004004001000000"
        ]
      }
   ```

2. 创建Model类

    ```dart 

      // YzBenchModel.dart

      import 'package:json_annotation/json_annotation.dart';

      part 'YzBenchModel.g.dart';

      @JsonSerializable()
      class YzBenchModel {
          YzBenchModel();

          List businessInfos;
          AccountInfo accountInfo;
          List buttonCodes;
          
          factory YzBenchModel.fromJson(Map<String,dynamic> json) => _$YzBenchModelFromJson(json);
          Map<String, dynamic> toJson() => _$YzBenchModelToJson(this);
      }

      // **************************************************************************

      @JsonSerializable()
      class AccountInfo {
        AccountInfo();

        String viewDataAccess;
        String operDataAccess;

        factory AccountInfo.fromJson(Map<String,dynamic> json) => _$AccountInfoFromJson(json);
        Map<String, dynamic> toJson() => _$AccountInfoToJson(this);
      }

      // **************************************************************************

      @JsonSerializable()
      class BusinessInfo {
        BusinessInfo();

        StoreInfo storeInfo;
        String businessName;
        List <MenuInfo> menuInfos;
        String businessId;


        factory BusinessInfo.fromJson(Map<String,dynamic> json) => _$BusinessInfoFromJson(json);
        Map<String, dynamic> toJson() => _$BusinessInfoToJson(this);
      }

      // **************************************************************************

      @JsonSerializable()
      class StoreInfo {
        StoreInfo();

        String address;
        num cityId;
        int storeType;
        String storeName;
        num storeId;
        String cityName;
        int deptType;

        factory StoreInfo.fromJson(Map<String,dynamic> json) => _$StoreInfoFromJson(json);
        Map<String, dynamic> toJson() => _$StoreInfoToJson(this);
      }
      // **************************************************************************

      @JsonSerializable()
      class MenuInfo {  
        MenuInfo();

        String menuGroupName;
        String menuGroupCode;
        List <SubMenuInfo> subMenuInfos;

        factory MenuInfo.fromJson(Map<String,dynamic> json) => _$MenuInfoFromJson(json);
        Map<String, dynamic> toJson() => _$MenuInfoToJson(this);
      }

      // **************************************************************************

      @JsonSerializable()
      class SubMenuInfo {
        SubMenuInfo();

        String icon;
        int count;
        String menuCode;
        int idx;
        String menuName;

        factory SubMenuInfo.fromJson(Map<String,dynamic> json) => _$SubMenuInfoFromJson(json);
        Map<String, dynamic> toJson() => _$SubMenuInfoToJson(this);
      }

      // **************************************************************************

    ```

    ```dart
      // YzBenchModel.g.dart

      part of 'YzBenchModel.dart';

      // **************************************************************************
      // JsonSerializableGenerator
      // **************************************************************************

      YzBenchModel _$YzBenchModelFromJson(Map<String, dynamic> json) {

        List businessInfos = json['businessInfos'] as List;
        List <BusinessInfo> tempList = [];
        for (int i = 0; i < businessInfos.length; i++) {
          BusinessInfo temp = BusinessInfo.fromJson(businessInfos[i] as Map);
          tempList.add(temp);
        }
        
        AccountInfo accountInfoModel = AccountInfo.fromJson(json['accountInfo']);

        return YzBenchModel()
          ..businessInfos = tempList
          ..accountInfo =  accountInfoModel
          ..buttonCodes = json['buttonCodes'] as List;
      }

      Map<String, dynamic> _$YzBenchModelToJson(YzBenchModel instance) =>
          <String, dynamic>{
            'businessInfos': instance.businessInfos,
            'accountInfo': instance.accountInfo,
            'buttonCodes': instance.buttonCodes
          };

      // **************************************************************************

      AccountInfo _$AccountInfoFromJson(Map<String, dynamic> json) {
        return AccountInfo()
          ..viewDataAccess = json['viewDataAccess']  
          ..operDataAccess = json['operDataAccess'];
      }

      Map<String, dynamic> _$AccountInfoToJson(AccountInfo instance) =>
          <String, dynamic>{
            'viewDataAccess': instance.viewDataAccess,
            'operDataAccess': instance.operDataAccess
          };

      // **************************************************************************

      BusinessInfo _$BusinessInfoFromJson(Map<String, dynamic> json) {
        
        StoreInfo storeInfo = StoreInfo.fromJson(json['storeInfo']);
        
        List menuInfos = json['menuInfos'] as List;
        List <MenuInfo> tempList = [];
        for (int i = 0; i < menuInfos.length; i++) {
          MenuInfo temp = MenuInfo.fromJson(menuInfos[i]);
          tempList.add(temp);
        }

        return BusinessInfo()
          ..storeInfo = storeInfo
          ..businessName = json['businessName']  
          ..menuInfos = tempList
          ..businessId = json['businessId'];
      }

      Map<String, dynamic> _$BusinessInfoToJson(BusinessInfo instance) =>
          <String, dynamic>{
            'storeInfo': instance.storeInfo,
            'businessName': instance.businessName,
            'menuInfos': instance.menuInfos,
            'businessId': instance.businessId
          };

      // **************************************************************************

      StoreInfo _$StoreInfoFromJson(Map<String, dynamic> json) {
        return StoreInfo()
          ..address = json['address']  
          ..cityId = json['cityId']  
          ..storeType = json['storeType'] 
          ..storeName = json['storeName'] 
          ..storeId = json['storeId'] 
          ..cityName = json['cityName'] 
          ..deptType = json['deptType'];
      }

      Map<String, dynamic> _$StoreInfoToJson(StoreInfo instance) =>
          <String, dynamic>{
            'address': instance.address,
            'cityId': instance.cityId,
            'storeType': instance.storeType,
            'storeName': instance.storeName,
            'storeId': instance.storeId,
            'cityName': instance.cityName,
            'deptType': instance.deptType,
          };

      // **************************************************************************

      MenuInfo _$MenuInfoFromJson(Map<String, dynamic> json) {

        List subMenuInfos = json['subMenuInfos'] as List;
        List <SubMenuInfo> tempList = [];
        for (int i = 0; i < subMenuInfos.length; i++) {
          SubMenuInfo temp = SubMenuInfo.fromJson(subMenuInfos[i]);
          tempList.add(temp);
        }

        return MenuInfo()
          ..subMenuInfos = tempList
          ..menuGroupName = json['menuGroupName']
          ..menuGroupCode = json['menuGroupCode'];
      }

      Map<String, dynamic> _$MenuInfoToJson(MenuInfo instance) =>
          <String, dynamic>{
            'subMenuInfos': instance.subMenuInfos,
            'menuGroupName': instance.menuGroupName,
            'menuGroupCode': instance.menuGroupCode
          };

      // **************************************************************************

      SubMenuInfo _$SubMenuInfoFromJson(Map<String, dynamic> json) {
        return SubMenuInfo()
          ..icon = json['icon']
          ..menuCode = json['menuCode']
          ..idx = json['idx']
          ..menuName = json['menuName'];
      }

      Map<String, dynamic> _$SubMenuInfoToJson(SubMenuInfo instance) =>
          <String, dynamic>{
            'icon': instance.icon,
            'menuCode': instance.menuCode,
            'idx': instance.idx,
            'menuName': instance.menuName,
          };
          
      // **************************************************************************


    ```

  这里创建了两个文件`YzBenchModel.dart`和`YzBenchModel.g.dart`，我是用的自动生成的方式。
  步骤如下：

  > 自动创建的model类只有最外层的model，其它的还得自己创建 ~ 你也可以不用这种方式，手动创建model类

  - 导入`json_model`依赖库。https://github.com/flutterchina/json_model

      ``` 
        # 在pubspec.ymal中添加依赖
        
        dev_dependencies:
          json_model: #latest version
          build_runner: ^1.0.0
          json_serializable: ^2.0.0
      ```
  - 将Json文件放入工程：
    - 创建一个与`lib`同级的目录`json`，放入Json文件。
    - 在`pubspec.ymal`中引入资源
        ``` 
          assets:
            # 假数据
            - jsons/YzBenchModel.json
        ```
  - 运行自动创建model类的命令，会自动创建类到`lib/models`目录下。创建的model类名和json文件名一致。

      ```shell
        flutter packages pub run json_model
      ```
  
      ![json_model](https://github.com/AllenSWB/notes/blob/master/src/imgs/flutter/json_model.png)

3. 使用

  ```dart
    Future<YzBenchModel> requestAPI() async {
      return DefaultAssetBundle.of(context).loadString("jsons/YzBenchModel.json").then(
         (onValue) {
           Map resultValue = json.decode(onValue);
           return YzBenchModel.fromJson(resultValue);
         },
       );
     } 
  ```