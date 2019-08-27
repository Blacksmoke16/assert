require "../spec_helper"

VALID_IPV4 = [
  "0.0.0.0",
  "10.0.0.0",
  "123.45.67.178",
  "172.16.0.0",
  "192.168.1.0",
  "224.0.0.1",
  "255.255.255.255",
  "127.0.0.0",
]

INVALID_IPV4 = [
  "0",
  "0.0",
  "0.0.0",
  "256.0.0.0",
  "0.256.0.0",
  "0.0.256.0",
  "0.0.0.256",
  "-1.0.0.0",
  "foobar",
]

VALID_IPV6 = [
  "2001:0db8:85a3:0000:0000:8a2e:0370:7334",
  "2001:0DB8:85A3:0000:0000:8A2E:0370:7334",
  "2001:0Db8:85a3:0000:0000:8A2e:0370:7334",
  "fdfe:dcba:9876:ffff:fdc6:c46b:bb8f:7d4c",
  "fdc6:c46b:bb8f:7d4c:fdc6:c46b:bb8f:7d4c",
  "fdc6:c46b:bb8f:7d4c:0000:8a2e:0370:7334",
  "fe80:0000:0000:0000:0202:b3ff:fe1e:8329",
  "fe80:0:0:0:202:b3ff:fe1e:8329",
  "fe80::202:b3ff:fe1e:8329",
  "0:0:0:0:0:0:0:0",
  "::",
  "0::",
  "::0",
  "0::0",
  # IPv4 mapped to IPv6
  "2001:0db8:85a3:0000:0000:8a2e:0.0.0.0",
  "::0.0.0.0",
  "::255.255.255.255",
  "::123.45.67.178",
]

INVALID_IPV6 = [
  "z001:0db8:85a3:0000:0000:8a2e:0370:7334",
  "fe80",
  "fe80:8329",
  "fe80:::202:b3ff:fe1e:8329",
  "fe80::202:b3ff::fe1e:8329",
  # IPv4 mapped to IPv6
  "2001:0db8:85a3:0000:0000:8a2e:0370:0.0.0.0",
  "::0.0",
  "::0.0.0",
  "::256.0.0.0",
  "::0.256.0.0",
  "::0.0.256.0",
  "::0.0.0.256",
]

IPV4_WHITESPACE = [
  "\x200.0.0.0",
  "\x09\x0910.0.0.0",
  "123.45.67.178\x0A",
  "172.16.0.0\x0D\x0D",
  "\x0B\x0B224.0.0.1\x0B\x0B",
]

describe Assert::Ip do
  assert_template(Assert::Assertions::Ip, "'{{property_name}}' is not a valid IP address")

  describe "#valid?" do
    assert_nil(Assert::Assertions::Ip)

    describe :mode do
      describe :ipv4 do
        describe "with valid ips" do
          it "should all be valid" do
            VALID_IPV4.each do |ip|
              Assert::Assertions::Ip(String?).new("prop", ip).valid?.should be_true
            end
          end
        end

        describe "with invalid ips" do
          it "should all be invalid" do
            INVALID_IPV4.each do |ip|
              Assert::Assertions::Ip(String?).new("prop", ip).valid?.should be_false
            end
          end
        end
      end

      describe :ipv6 do
        describe "with valid ips" do
          it "should all be valid" do
            VALID_IPV6.each do |ip|
              Assert::Assertions::Ip(String?).new("prop", ip, version: :ipv6).valid?.should be_true
            end
          end
        end

        describe "with invalid ips" do
          it "should all be invalid" do
            INVALID_IPV6.each do |ip|
              Assert::Assertions::Ip(String?).new("prop", ip, version: :ipv6).valid?.should be_false
            end
          end
        end
      end
    end

    describe :normalizer do
      it "should be normalized to be valid" do
        IPV4_WHITESPACE.each do |ip|
          Assert::Assertions::Ip(String?).new("prop", ip, normalizer: ->(actual : String) { actual.strip }).valid?.should be_true
        end
      end
    end
  end
end
