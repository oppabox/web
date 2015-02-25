ActiveAdmin.register AdminUser do
  menu label: "관리자 계정", :priority => 9
  permit_params :email, :password, :password_confirmation, :registration_number, :representative, :contact_email, :phonenumber
  actions :all, except: [ :show ]
  
  index :title => '관리자 계정 리스트' do
    id_column
    column "이메일", :email
    column "사업자등록번호", :registration_number
    column "담당자(이메일)" do |a|
      rep = a.representative.nil? ? "" : a.representative
      mail = (a.contact_email.nil? or (a.contact_email == "")) ? "" : "(" + a.contact_email + ")"
      rep + mail
    end
    column "연락처", :phonenumber
    column "생성일", :created_at
    column "최근 접속일", :current_sign_in_at
    actions
  end

  filter :email, label: "이메일"
  filter :registration_number, label: "사업자등록번호"
  filter :representative, label: "담당자"
  filter :contact_email, label: "담당자 이메일"
  filter :phonenumber, label: "연락처"
  filter :created_at, label: "생성일"
  filter :current_sign_in_at, label: "최근 접속일"

  form do |f|
    f.inputs "관리자 계정 정보" do
      f.input :email, label: "이메일"
      f.input :password, label: "비밀번호" 
      f.input :password_confirmation, label: "비밀번호 재입력"
      f.input :registration_number, label: "사업자등록번호"
      f.input :representative, label: "담당자"
      f.input :contact_email, label: "담당자 이메일"
      f.input :phonenumber, label: "연락처"
    end
    f.actions
  end

end
