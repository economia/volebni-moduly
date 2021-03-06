// Generated by LiveScript 1.2.0
(function(){
  var xml2js, computePreferentialVotes, getCandidateId;
  xml2js = require('xml2js');
  module.exports.parse = function(csvString, preferentialVotesXml){
    var preferentialVotesAssoc, lines, list;
    preferentialVotesAssoc = computePreferentialVotes(preferentialVotesXml);
    lines = csvString.split("\n");
    lines.shift();
    list = lines.filter(function(it){
      return it.length;
    }).map(function(line){
      var ref$, countyId, partyId, rank, name, surname, title1, title2, age, occupation, residence, residenceCode, party, suggParty, isInvalid, id, votes;
      ref$ = line.split(";"), countyId = ref$[0], partyId = ref$[1], rank = ref$[2], name = ref$[3], surname = ref$[4], title1 = ref$[5], title2 = ref$[6], age = ref$[7], occupation = ref$[8], residence = ref$[9], residenceCode = ref$[10], party = ref$[11], suggParty = ref$[12], isInvalid = ref$[13];
      if (isInvalid === "1") {
        return null;
      }
      countyId = +countyId;
      partyId = +partyId;
      rank = +rank;
      id = getCandidateId(countyId, partyId, rank);
      votes = +preferentialVotesAssoc[id];
      return {
        countyId: countyId,
        partyId: partyId,
        rank: rank,
        name: name,
        surname: surname,
        title1: title1,
        title2: title2,
        votes: votes
      };
    }).filter(function(it){
      return it !== null;
    }).sort(function(a, b){
      var that;
      switch (false) {
      case !(that = a.countyId - b.countyId):
        return that;
      case !(that = a.partyId - b.partyId):
        return that;
      default:
        return a.rank - b.rank;
      }
    });
    return list;
  };
  computePreferentialVotes = function(preferentialVotesXml){
    var preferentialVotesAssoc;
    preferentialVotesAssoc = {};
    preferentialVotesXml.VYSLEDKY_KANDID.KRAJ.forEach(function(county){
      var countyId, ref$;
      countyId = +county.$.CIS_KRAJ;
      return (ref$ = county.KANDIDATI[0].KANDIDAT) != null ? ref$.forEach(function(candidate){
        var partyId, rank, votes, id;
        partyId = +candidate.$.KSTRANA;
        rank = +candidate.$.PORCISLO;
        votes = +candidate.$.HLASY;
        id = getCandidateId(countyId, partyId, rank);
        return preferentialVotesAssoc[id] = votes;
      }) : void 8;
    });
    return preferentialVotesAssoc;
  };
  getCandidateId = function(countyId, partyId, rank){
    return countyId + "-" + partyId + "-" + rank;
  };
}).call(this);
