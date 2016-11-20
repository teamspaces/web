require "test_helper"

describe UrlParameterHelper do
  let(:person_param_key) { "person" }
  let(:person_param_value) { "first" }
  let(:person_param) { "#{person_param_key}=#{person_param_value}" }
  let(:url_without_params) { "www.spaces.is/hello"}
  let(:url_with_person_param) { "#{url_without_params}?#{person_param}"}

  subject { Object.new.extend(UrlParameterHelper) }

  describe "#parameter_value" do
    context "url with param key" do
      it "returns param value" do
        url_person_param = subject.parameter_value(url_with_person_param, person_param_key)
        assert_equal person_param_value, url_person_param
      end
    end

    context "url without param key" do
      it "returns nil" do
        url_person_param = subject.parameter_value(url_without_params, person_param_key)
        assert_nil url_person_param
      end
    end
  end

  describe "#add_parameter_to_url" do
    let(:param_key) { "city" }
    let(:param_value) { "newyork" }

    context "url with several params" do
      it "appends param" do
        url = subject.add_parameter_to_url(url_with_person_param, param_key, param_value)

        assert_match person_param, url
        assert_match "#{param_key}=#{param_value}", url
      end
    end

    context "url without params" do
      it "sets param" do
        url = subject.add_parameter_to_url(url_without_params, param_key, param_value)

        assert_match "?#{param_key}=#{param_value}", url
      end
    end
  end

  describe "#remove_parameter_from_url" do
    it "removes param from url" do
      url = subject.remove_parameter_from_url(url_with_person_param, person_param_key)

      assert_no_match person_param, url
    end
  end
end
