/**
 * 필터링 API 테스트 스크립트
 *
 * 실행 방법:
 * node testFilteringAPI.js
 */

const axios = require('axios');

// 백엔드 URL (환경에 맞게 수정)
const BASE_URL = process.env.API_URL || 'http://localhost:3001';

async function testFiltering() {
  console.log('🧪 필터링 API 테스트 시작...\n');

  // 테스트 1: 기본 검색
  console.log('1️⃣  기본 검색 테스트');
  try {
    const response = await axios.get(`${BASE_URL}/api/policies/search`, {
      params: {
        query: '청년',
        page: 1,
        limit: 5
      }
    });
    console.log(`✅ 성공: ${response.data.total}개 정책 발견`);
    console.log(`   첫 번째 정책: ${response.data.data[0]?.plcyNm || 'N/A'}\n`);
  } catch (error) {
    console.error(`❌ 실패: ${error.message}\n`);
  }

  // 테스트 2: 카테고리 필터
  console.log('2️⃣  카테고리 필터 테스트 (취업지원)');
  try {
    const response = await axios.get(`${BASE_URL}/api/policies/search`, {
      params: {
        mainCategory: '일자리',
        limit: 5
      }
    });
    console.log(`✅ 성공: ${response.data.total}개 취업지원 정책 발견`);
    console.log(`   첫 번째 정책: ${response.data.data[0]?.plcyNm || 'N/A'}\n`);
  } catch (error) {
    console.error(`❌ 실패: ${error.message}\n`);
  }

  // 테스트 3: 지역 필터
  console.log('3️⃣  지역 필터 테스트 (서울)');
  try {
    const response = await axios.get(`${BASE_URL}/api/policies/search`, {
      params: {
        region: '서울',
        limit: 5
      }
    });
    console.log(`✅ 성공: ${response.data.total}개 서울 정책 발견`);
    console.log(`   첫 번째 정책: ${response.data.data[0]?.plcyNm || 'N/A'}\n`);
  } catch (error) {
    console.error(`❌ 실패: ${error.message}\n`);
  }

  // 테스트 4: 취업요건 필터
  console.log('4️⃣  취업요건 필터 테스트 (미취업자)');
  try {
    const response = await axios.get(`${BASE_URL}/api/policies/search`, {
      params: {
        employmentCode: '0013003', // 미취업자
        limit: 5
      }
    });
    console.log(`✅ 성공: ${response.data.total}개 미취업자 대상 정책 발견`);
    console.log(`   첫 번째 정책: ${response.data.data[0]?.plcyNm || 'N/A'}\n`);
  } catch (error) {
    console.error(`❌ 실패: ${error.message}\n`);
  }

  // 테스트 5: 학력요건 필터
  console.log('5️⃣  학력요건 필터 테스트 (대학 재학)');
  try {
    const response = await axios.get(`${BASE_URL}/api/policies/search`, {
      params: {
        educationCode: '0049005', // 대학 재학
        limit: 5
      }
    });
    console.log(`✅ 성공: ${response.data.total}개 대학 재학생 대상 정책 발견`);
    console.log(`   첫 번째 정책: ${response.data.data[0]?.plcyNm || 'N/A'}\n`);
  } catch (error) {
    console.error(`❌ 실패: ${error.message}\n`);
  }

  // 테스트 6: 복합 필터 (카테고리 + 지역 + 취업요건)
  console.log('6️⃣  복합 필터 테스트 (취업지원 + 서울 + 미취업자)');
  try {
    const response = await axios.get(`${BASE_URL}/api/policies/search`, {
      params: {
        mainCategory: '일자리',
        region: '서울',
        employmentCode: '0013003',
        limit: 5
      }
    });
    console.log(`✅ 성공: ${response.data.total}개 정책 발견`);
    if (response.data.data.length > 0) {
      console.log(`   첫 번째 정책: ${response.data.data[0]?.plcyNm || 'N/A'}`);
    } else {
      console.log('   (조건에 맞는 정책 없음)');
    }
    console.log();
  } catch (error) {
    console.error(`❌ 실패: ${error.message}\n`);
  }

  console.log('🎉 테스트 완료!');
}

// 실행
testFiltering().catch(console.error);
