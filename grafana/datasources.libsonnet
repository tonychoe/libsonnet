{
  new(name, url, type, default=false):: {
    name: name,
    type: type,
    access: 'proxy',
    url: url,
    isDefault: default,
    version: 1,
    editable: false,
  },
  withBasicAuth(username, password):: {
    basicAuth: true,
    basicAuthUser: username,
    // basicAuthPassword: password,
  },
  withJsonData(data):: {
    jsonData+: data,
  },
  withHttpMethod(httpMethod):: self.withJsonData({ httpMethod: httpMethod }),

  // Custom
  withSecureJsonData(data):: {
    secureJsonData+: data,
  },
  withEditable(editable):: {
    editable: editable,
  },
  withUid(uid):: {
    uid: uid,
  },
  withDerivedFields(datasourceUid, matcherRegex, name, url):: self.withJsonData({
    derivedFields+: [{
      datasourceUid: datasourceUid,
      matcherRegex: matcherRegex,
      name: name,
      url: url,
    }],
  }),
  withTraceToLogs(datasourceUid, tags, mappedTags, mapTagNamesEnabled, spanStartTimeShift, spanEndTimeShift, filterByTraceID, filterBySpanID, lokiSearch):: self.withJsonData({
    tracesToLogs+: {
      datasourceUid: datasourceUid,
      tags: tags,
      mappedTags: mappedTags,
      mapTagNamesEnabled: mapTagNamesEnabled,
      spanStartTimeShift: spanStartTimeShift,
      spanEndTimeShift: spanEndTimeShift,
      filterByTraceID: filterByTraceID,
      filterBySpanID: filterBySpanID,
      lokiSearch: lokiSearch,
    },
  }),
  withAlertingSettings(manageAlerts, datasourceUid):: self.withJsonData({
    manageAlerts: manageAlerts,
    alertmanagerUid: datasourceUid,
  }),
  withServiceGraphSettings(datasourceUid):: self.withJsonData({
    serviceMap+: {
      datasourceUid: datasourceUid,
    },
  }),
  withNodeGraph(enabled):: self.withJsonData({
    nodeGraph+: {
      enabled: enabled,  // boolean
    },
  }),
  withExemplars(datasourceUid, name):: self.withJsonData({
    exemplarTraceIdDestinations+: [{
      datasourceUid: datasourceUid,
      name: name,
    }],
  }),
}
