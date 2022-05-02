package test

import (
	"fmt"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"io/ioutil"
	"net/http"
	"strings"
	"testing"
)

var region = "us-east-1"
var bucket = ""

// TestExamplesComplete tests a typical deployment of this module
func TestExamplesComplete(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir:  "../../examples/complete",
		BackendConfig: map[string]interface{}{},
		EnvVars:       map[string]string{},
		Vars:          map[string]interface{}{},
	}
	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApplyAndIdempotent(t, terraformOptions)
	bucket = terraform.Output(t, terraformOptions, "bucket")

	httpTest(t, "http://terraform-aws-alb.oss.champtest.net")
	httpTest(t, "https://terraform-aws-alb.oss.champtest.net")
	bucketTest(t, bucket)
}

// httpTest calls the given url and ensures a successful response
func httpTest(t *testing.T, url string) {
	t.Log("Calling http url:", url)
	resp, err := http.Get(url)
	assert.NoError(t, err)

	t.Log("status code:", resp.StatusCode)
	assert.Equal(t, 200, resp.StatusCode)

	body, err := ioutil.ReadAll(resp.Body)
	assert.NoError(t, err)
	t.Log("http response body:", string(body))
	assert.True(t, strings.Contains(string(body), "successful"))
}

// bucketTest asserts that the bucket contains ALB logs
func bucketTest(t *testing.T, bucket string) {
	fmt.Println("Getting AWS Session")
	sess, err := session.NewSessionWithOptions(session.Options{
		SharedConfigState: session.SharedConfigEnable,
	})
	if err != nil {
		panic(err)
	}

	t.Log("Listing contents for bucket:", bucket)
	svc := s3.New(sess, aws.NewConfig().WithRegion(region))
	output, err := svc.ListObjects(&s3.ListObjectsInput{
		Bucket: aws.String(bucket),
		Prefix: nil,
	})
	assert.NoError(t, err)
	for _, obj := range output.Contents {
		fmt.Println(*obj.Key)
	}
	assert.GreaterOrEqual(t, len(output.Contents), 1)
}
